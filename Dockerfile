# Use the official PHP image as the base image
FROM php:8.2-fpm

# Set the working directory inside the container
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set environment variable to allow Composer plugins as superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy composer.json and composer.lock to container
COPY composer.json composer.lock ./

# Delete existing vendor directory and composer.lock
#RUN rm -rf vendor composer.lock

# Install project dependencies
RUN composer install --no-autoloader

# Copy application code to container
COPY . .

# Generate autoload files
RUN composer dump-autoload

# Expose port 9000 and start the PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
