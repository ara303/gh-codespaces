FROM wordpress:php8.2-apache

# Install additional PHP extensions and tools
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip exif \
    && a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Add wp-cli bash completion
RUN curl -o /etc/bash_completion.d/wp-cli -L https://raw.githubusercontent.com/wp-cli/wp-cli/main/utils/wp-completion.bash

# Configure Apache to use the correct document root
RUN sed -i 's/\/var\/www\/html/\/var\/www\/html/g' /etc/apache2/sites-available/000-default.conf

# Fix permissions
RUN chown -R www-data:www-data /var/www/html
