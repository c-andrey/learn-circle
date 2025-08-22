#!/bin/sh
set -e

# Rodar scripts do Composer após o código estar completo
composer run-script post-autoload-dump || true

# Limpar caches do Laravel
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

# Caso queira rodar migrations automaticamente (opcional)
# php artisan migrate --force

# Inicia o PHP-FPM
exec php-fpm
