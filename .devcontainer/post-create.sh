#!/bin/bash

# Make sure Apache is running
service apache2 start

# Wait for database to be ready
echo "Waiting for database connection..."
for i in {1..30}; do
  if mysql -h db -u wordpress -pwordpress -e "SELECT 1" &> /dev/null; then
    echo "Database connection established!"
    break
  fi
  echo "Waiting for database... ($i/30)"
  sleep 2
done

# Setup WordPress
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f wp-config.php ]; then
  echo "Downloading WordPress..."
  wp core download --allow-root
  
  # Create config
  echo "Creating WordPress configuration..."
  wp config create --allow-root --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=db
  
  # Install WordPress
  echo "Installing WordPress..."
  wp core install --allow-root --url=http://localhost --title="WordPress Dev Site" --admin_user=admin --admin_password=password --admin_email=admin@example.com
  
  # Enable debug mode
  wp config set WP_DEBUG true --allow-root --raw
  
  echo "WordPress setup complete!"
else
  echo "WordPress already installed."
fi

# Create symbolic links for development
mkdir -p /workspace/wp-content
if [ ! -L "/workspace/wp-content/themes" ]; then
  ln -sf /var/www/html/wp-content/themes /workspace/wp-content/themes
fi
if [ ! -L "/workspace/wp-content/plugins" ]; then
  ln -sf /var/www/html/wp-content/plugins /workspace/wp-content/plugins
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

echo "Setup complete! WordPress is running at http://localhost"
