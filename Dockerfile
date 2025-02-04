# Use PHP with FPM (FastCGI Process Manager) for Nginx
FROM php:7.4-fpm

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip exif \
    && docker-php-ext-enable exif \
    && apt-get clean

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html

# Copy application files from the host to the container
COPY ./app /var/www/html

# Set permissions for TastyIgniter
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Add a cronjob for TastyIgniter's Laravel scheduler
RUN echo "* * * * * www-data /usr/local/bin/php /var/www/html/artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/tastyigniter-scheduler

# Apply cronjob and start cron service
RUN chmod 0644 /etc/cron.d/tastyigniter-scheduler \
    && crontab /etc/cron.d/tastyigniter-scheduler

# Expose the FastCGI port for Nginx
EXPOSE 9000

# Start PHP-FPM and Cron together
CMD ["sh", "-c", "service cron start && php-fpm"]
