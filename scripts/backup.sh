#!/bin/bash
kubectl exec mysql -- mysqldump -u wpuser -pwppass wpdb > backup.sql
kubectl cp loja-roupas-wordpress-1:/var/www/html ./backup_html