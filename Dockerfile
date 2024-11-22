# Use an official PHP image with Composer
FROM php:8.2-fpm-alpine

# Install required dependencies including Git and Composer
RUN apk add --no-cache \
    git \
    bash \
    vim \
    libpng-dev \
    libjpeg-turbo-dev \
    libfreetype6-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Set safe directory for Git
RUN git config --global --add safe.directory /var/www/html

# Copy the application files into the container
COPY . /var/www/html

# Set file permissions for Laravel
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Install Composer dependencies (Laravel dependencies)
RUN composer install --no-interaction --optimize-autoloader

# Expose the port the app runs on
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
