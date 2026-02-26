
#!/bin/bash
set -e

source .env

# Aguarda o WordPress estar no ar
until docker compose exec -T wordpress bash -c "curl -sSf http://localhost" >/dev/null 2>&1; do
  echo "Aguardando WordPress subir..."
  sleep 5
done

echo "Instalando WordPress via WP-CLI..."
# Instala WP se ainda não instalado
if ! docker compose run --rm wpcli wp core is-installed; then
  docker compose run --rm wpcli wp core install     --url="$SITE_URL"     --title="$SITE_TITLE"     --admin_user="$ADMIN_USER"     --admin_password="$ADMIN_PASSWORD"     --admin_email="$ADMIN_EMAIL"
fi

# Idioma e timezone
docker compose run --rm wpcli wp language core install $LOCALE --activate
docker compose run --rm wpcli wp option update timezone_string "$TIMEZONE"

# Permalinks
docker compose run --rm wpcli wp rewrite structure '/%postname%/' --hard

# Temas e plugins
docker compose run --rm wpcli wp theme install storefront --activate

docker compose run --rm wpcli wp plugin install   woocommerce   woocommerce-extra-checkout-fields-for-brazil   woocommerce-pagseguro   woocommerce-correios   wordpress-seo   --activate

# Cria páginas básicas
HOME_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Home' --post_status=publish --porcelain)
SHOP_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Loja' --post_status=publish --porcelain)
CART_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Carrinho' --post_status=publish --porcelain)
CHECKOUT_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Finalizar compra' --post_status=publish --porcelain)
ACCOUNT_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Minha conta' --post_status=publish --porcelain)
EXCHANGE_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Política de Troca e Devolução' --post_status=publish --post_content='Descreva aqui sua política de trocas, prazos, condições e reembolsos.' --porcelain)
CONTACT_ID=$(docker compose run --rm wpcli wp post create --post_type=page --post_title='Contato' --post_status=publish --porcelain)

# Define Home como página inicial e Loja como página de posts da loja (catálogo)
docker compose run --rm wpcli wp option update show_on_front 'page'
docker compose run --rm wpcli wp option update page_on_front $HOME_ID

# Configura páginas do WooCommerce
# Atribui páginas para loja/carrinho/checkout/conta
docker compose run --rm wpcli wp option update woocommerce_shop_page_id $SHOP_ID
docker compose run --rm wpcli wp option update woocommerce_cart_page_id $CART_ID
docker compose run --rm wpcli wp option update woocommerce_checkout_page_id $CHECKOUT_ID
docker compose run --rm wpcli wp option update woocommerce_myaccount_page_id $ACCOUNT_ID

# Cria menu principal e adiciona itens
MENU_ID=$(docker compose run --rm wpcli wp menu create "Menu Principal" --porcelain)
docker compose run --rm wpcli wp menu location assign "$MENU_ID" primary
for ID in $HOME_ID $SHOP_ID $CART_ID $CHECKOUT_ID $ACCOUNT_ID $CONTACT_ID; do
  docker compose run --rm wpcli wp menu item add-post "$MENU_ID" $ID
done

# Conteúdo da Home com bloco simples e produtos em destaque
HOME_CONTENT='<!-- wp:cover {"overlayColor":"black","minHeight":50,"minHeightUnit":"vh","isDark":true} -->
<div class="wp-block-cover is-dark" style="min-height:50vh"><span aria-hidden="true" class="wp-block-cover__background has-black-background-color has-background-dim-100 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:heading {"textAlign":"center","level":1,"textColor":"white"} -->
<h1 class="has-text-align-center has-white-color has-text-color">Nova Coleção</h1>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","textColor":"white"} -->
<p class="has-text-align-center has-white-color has-text-color">Moda que combina com o seu estilo</p>
<!-- /wp:paragraph --></div></div>
<!-- /wp:cover -->

<!-- wp:heading -->
<h2>Produtos em destaque</h2>
<!-- /wp:heading -->

<!-- wp:shortcode -->
[products limit="8" columns="4" visibility="featured"]
<!-- /wp:shortcode -->'

docker compose run --rm wpcli wp post update $HOME_ID --post_content="$HOME_CONTENT"

echo "Pronto! Acesse $SITE_URL para ver sua loja. Login: $ADMIN_USER / (senha definida)."
