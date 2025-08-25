# 1. Imagem base PHP com FPM
FROM php:8.2-fpm AS base

# 2. Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev netcat-openbsd \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# 3. Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Definir diretório de trabalho
WORKDIR /var/www/html

# 5. Copiar arquivos do Composer
COPY app-laravel/composer.json app-laravel/composer.lock ./

# 6. Instalar dependências de produção
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction --no-progress

# 7. Copiar o restante do código
COPY app-laravel/ .

# 8. Ajustar permissões
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Copia entrypoint
COPY infra/docker/laravel/entrypoint.prod.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 10. Rodar como www-data
USER www-data

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
