#!/usr/bin/env bash
set -e

cd /var/www/html

# Instala dependências (por segurança em deploys com volume)
if [ ! -d vendor ] || [ -z "$(ls -A vendor 2>/dev/null)" ]; then
  composer install --no-dev --optimize-autoloader
fi

# Ajusta permissões
chown -R www-data:www-data storage bootstrap/cache || true
chmod -R 775 storage bootstrap/cache || true

# Espera MySQL
echo "Aguardando DB em ${DB_HOST:-db}:${DB_PORT:-3306}..."
until nc -z ${DB_HOST:-db} ${DB_PORT:-3306}; do
  sleep 1
done

# Cache e migrações
php artisan config:cache
php artisan route:cache || true
php artisan view:cache || true
php artisan migrate --force || true

exec "$@"