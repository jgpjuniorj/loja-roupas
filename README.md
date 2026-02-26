
# Loja de Roupas (Open Source) – WordPress + WooCommerce (Docker)

Este pacote entrega uma loja virtual **pronta** para você começar a vender roupas. É baseada em tecnologias **open source** (WordPress + WooCommerce) e já vem com layout, páginas e plugins essenciais no idioma **Português do Brasil**.

## O que vem pronto
- WordPress + WooCommerce em Docker
- Tema **Storefront** ativado (leve e pronto para loja)
- Páginas criadas: Home, Loja, Carrinho, Finalizar compra, Minha Conta, Contato, Política de Troca
- Menu principal configurado
- Permalinks amigáveis configurados
- Idioma pt_BR e fuso horário America/Sao_Paulo
- Plugins úteis para o Brasil:
  - WooCommerce (loja)
  - Campos Extras Brasil (endereços com CPF/CNPJ) 
  - PagSeguro (meio de pagamento)
  - Correios (frete)
  - Yoast SEO
- Página inicial com herói + vitrine de produtos em destaque
- Arquivo `produtos-exemplo.csv` para importar produtos rapidamente

## Requisitos
- Docker e Docker Compose instalados
- Porta **8080** livre no seu computador/servidor

## Como subir a loja
```bash
# 1) Clone este projeto ou extraia o zip
cd loja-roupas-woocommerce

# 2) Suba os containers
docker compose up -d

# 3) Rode o script de inicialização (apenas na primeira vez)
chmod +x scripts/init.sh
./scripts/init.sh
```
Acesse: **http://localhost:8080**  
Painel: **http://localhost:8080/wp-admin**

> **Login**: o usuário e senha são definidos no arquivo `.env`. **Troque a senha** `TroqueEstaSenha!` antes de subir em produção.

## Importar produtos de exemplo (opcional)
1. Entre em **Produtos → Importar**
2. Envie o arquivo `produtos-exemplo.csv`
3. Marque a opção de atualizar dados se necessário
4. Mapeie as colunas (o WooCommerce geralmente reconhece automaticamente)

> Para imagens, adicione os arquivos `camiseta-basica.jpg`, `calca-jeans.jpg`, `vestido-floral.jpg`, `tenis-branco.jpg` na **Mídia** ou informe URLs completas no CSV.

## Ativar Pagamentos e Frete
- **PagSeguro**: em **WooCommerce → Configurações → Pagamentos → PagSeguro**, conecte sua conta e habilite cartão/boleto/pix (se disponível no plugin).
- **Correios**: em **WooCommerce → Configurações → Entrega → Correios**, informe CEP de origem e serviços desejados.

## Personalizar o layout
- **Aparência → Personalizar** para trocar cores, logo, tipografia e rodapé.
- Se quiser templates prontos, você pode instalar o plugin **Starter Templates** (Astra) e migrar de tema depois.

## Produção (domínio e HTTPS)
- Altere `SITE_URL` no `.env` para seu domínio real (ex.: `https://minhaloja.com.br`).
- Proxie a porta 8080 atrás de um **Nginx/Traefik** com **Let's Encrypt** para HTTPS.
- Configure backups do volume `wp_data` e do banco `db_data`.

## Dicas de segurança
- Troque senhas do `.env` (banco e admin)
- Crie um usuário admin nominal e remova o genérico `admin`
- Mantenha plugins/tema/WordPress atualizados

## Suporte rápido
Se precisar, posso ajustar o pacote com um tema específico, páginas adicionais ou integrações (Mercado Pago, Bling/ERP etc.).
