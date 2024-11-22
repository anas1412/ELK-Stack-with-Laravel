# Use the official PHP 8.2 image with FPM
FROM php:8.2-fpm

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel application
COPY . .

# Install PHP dependencies with Composer (production only)
RUN composer install --no-dev --optimize-autoloader

# Generate Laravel APP_KEY
#RUN php artisan key:generate

# Set proper permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 for PHP-FPM (used by Nginx)
EXPOSE 9000

# Set up Laravel configuration and caches (only if config is correct)
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Start PHP-FPM
CMD ["php-fpm"]

