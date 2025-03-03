FROM mcr.microsoft.com/vscode/devcontainers/php:0-8.2

# Install prerequisites
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    mariadb-client \
    apache2 \
    libapache2-mod-php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    php-soap \
    php-intl \
    less \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Setup Apache 
RUN a2enmod rewrite
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Configure user
RUN echo "export PATH=\$PATH:/usr/local/bin" >> /home/vscode/.bashrc

# Create wordpress directory if it doesn't exist
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
