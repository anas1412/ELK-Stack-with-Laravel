# Step 1: Use PHP 8.2 with Apache base image
FROM php:8.2-apache

# Step 2: Install system dependencies for Laravel and Apache
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Step 3: Enable mod_rewrite for Apache (needed for Laravel routes)
RUN a2enmod rewrite

# Step 4: Install Composer (for managing Laravel dependencies)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Step 5: Set up working directory in the container
WORKDIR /var/www/html

# Step 6: Copy the contents of the 'src' folder into /var/www/html
COPY ./src/. /var/www/html/

# Step 7: Copy custom Apache config to container
COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy the wait-for-it script into the container
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Step 8: Install Laravel's PHP dependencies
RUN composer install --no-interaction --optimize-autoloader

# Step 9: Set proper permissions for Laravel's storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Step 10: Expose the Apache port 80
EXPOSE 80
