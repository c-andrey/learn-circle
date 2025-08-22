# 1. Imagem base PHP com FPM
FROM php:8.2-fpm

# 2. Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 3. Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Definir diretório de trabalho
WORKDIR /var/www/html

# 5. Copiar apenas composer.* para cache eficiente
COPY ../../app-laravel/composer.json ../../app-laravel/composer.lock ./

# 6. Instalar dependências
RUN composer install --no-dev --optimize-autoloader

# 7. Copiar o restante do código
COPY ../../app-laravel .

# 8. Dar permissão para storage e bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# 9. Rodar como www-data
USER www-data
