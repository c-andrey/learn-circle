#!/usr/bin/env bash
set -e

cd /var/www/html

# Garante .env (dev)
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

# Instala dependências se vendor estiver vazio
if [ ! -d vendor ] || [ -z "$(ls -A vendor 2>/dev/null)" ]; then
  composer install
fi

# Gera APP_KEY se estiver vazio no .env
if ! grep -qE '^APP_KEY=.+$' .env || grep -qE '^APP_KEY=\s*$' .env; then
  php artisan key:generate --force || true
fi

# Ajusta permissões básicas
chmod -R 775 storage bootstrap/cache || true

# Espera MySQL
echo "Aguardando DB em ${DB_HOST:-db}:${DB_PORT:-3306}..."
until nc -z ${DB_HOST:-db} ${DB_PORT:-3306}; do
  sleep 1
done

# Migrações (dev sem --force)
php artisan migrate || true

exec "$@"