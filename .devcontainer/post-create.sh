#!/bin/bash

# Wait for database to be ready
echo "Waiting for database connection..."
until mysql -h db -u wordpress -pwordpress -e "SELECT 1"; do
  sleep 1
done
echo "Database connection established!"

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Setting up WordPress..."
  
  # Download WordPress core files if they don't exist
  if [ ! -f /var/www/html/wp-admin/index.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
  fi
  
  # Create wp-config.php
  wp config create --allow-root --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=db --path=/var/www/html
  
  # Install WordPress
  wp core install --allow-root --url=http://localhost --title="WordPress Dev Site" --admin_user=admin --admin_password=password --admin_email=admin@example.com
  
  # Enable debug mode
  wp config set WP_DEBUG true --allow-root
  wp config set WP_DEBUG_LOG true --allow-root
  wp config set WP_DEBUG_DISPLAY true --allow-root
  
  echo "WordPress setup complete!"
else
  echo "WordPress already installed."
fi

# Fix permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
