FROM php:8.4-fpm

RUN apt-get update && apt install -y \
    git curl zip unzip \
    libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath xml dom fileinfo

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
