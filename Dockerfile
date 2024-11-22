FROM php:8.2-fpm

# Install NGINX
RUN apt-get update && apt-get install -y nginx

# Remove the default server configuration
RUN rm /etc/nginx/sites-enabled/default

# Copy NGINX config and PHP file into the container
COPY nginx.conf /etc/nginx/sites-available/default
COPY index.php /var/www/html/

# Expose the HTTP port
EXPOSE 80

# Start both NGINX and PHP-FPM
CMD service nginx start && php-fpm
