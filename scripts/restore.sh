#!/bin/bash
kubectl exec -i mysql -- mysql -u wpuser -pwppass wpdb < backup.sql
kubectl cp ./backup_html loja-roupas-wordpress-1:/var/www/html