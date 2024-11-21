FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git curl libzip-dev unzip \
    && docker-php-ext-install pdo_mysql zip

WORKDIR /var/www/html
