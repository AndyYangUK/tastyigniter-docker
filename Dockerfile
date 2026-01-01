FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev \
    libzip-dev libxml2-dev libicu-dev libonig-dev \
    libcurl4-openssl-dev \
    curl unzip git && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
# Removed curl, openssl, and ctype as they are built-in to the base image
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    dom \
    exif \
    gd \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    zip

# Enable Apache rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Download TastyIgniter v4
RUN composer create-project tastyigniter/tastyigniter . --no-interaction --prefer-dist

RUN php artisan storage:link

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Update Apache DocumentRoot to point to /public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/defaults!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80

CMD ["apache2-foreground"]
