# Use PHP 8.2 with FPM (FastCGI Process Manager) as the base image
FROM php:8.2-fpm

# Install NGINX
RUN apt-get update && apt-get install -y nginx

# Remove the default server configuration from NGINX
RUN rm /etc/nginx/sites-enabled/default

# Copy the custom NGINX configuration file into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the PHP files into the container (your PHP application)
COPY index.php /var/www/html/

# Expose port 80 for the web server
EXPOSE 80

# Start both NGINX and PHP-FPM in the container
CMD service nginx start && php-fpm
