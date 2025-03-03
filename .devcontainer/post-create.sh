#!/bin/bash

# Ensure Apache is set to start
sudo service apache2 start

# Wait for database
echo "Waiting for database connection..."
until mysql -h db -u wordpress -pwordpress -e "SELECT 1"; do
  sleep 1
done

# Move to WordPress directory
cd /var/www/html

# Download and install WordPress if not already there
if [ ! -f wp-config.php ]; then
  echo "Setting up WordPress..."
  
  # Download WordPress
  sudo -u www-data wp core download
  
  # Create config
  sudo -u www-data wp config create --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=db
  
  # Install WordPress
  sudo -u www-data wp core install --url=http://localhost --title="WordPress Dev Site" --admin_user=admin --admin_password=password --admin_email=admin@example.com
  
  # Enable debugging
  sudo -u www-data wp config set WP_DEBUG true --raw
  
  echo "WordPress installed successfully!"
else
  echo "WordPress already installed"
fi

# Create a symbolic link from workspace to WordPress themes directory for theme development
if [ ! -L "/workspaces/${PWD##*/}/wp-content" ]; then
  echo "Creating symbolic link to WordPress content directory..."
  mkdir -p /workspaces/${PWD##*/}/wp-content
  ln -sf /var/www/html/wp-content /workspaces/${PWD##*/}/wp-content
fi

# Fix permissions
sudo chown -R www-data:www-data /var/www/html
echo "Setup complete! WordPress is available at http://localhost"
