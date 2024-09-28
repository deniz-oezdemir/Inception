#!/bin/bash

# Read passwords from files
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Change ownership of /var/www/inception/ directory to www-data user and group
chown -R www-data:www-data /var/www/inception/

# Always remove the existing wp-config.php file
if [ -f /var/www/inception/wp-config.php ]; then
    echo "Removing existing wp-config.php file..."
    rm /var/www/inception/wp-config.php
fi

# Create wp-config.php file with the necessary configurations
cat <<EOF > /var/www/inception/wp-config.php
<?php
// Define database constants
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', getenv('DB_HOST'));

// Define WordPress URLs
define('WP_HOME', getenv('WP_FULL_URL'));
define('WP_SITEURL', getenv('WP_FULL_URL'));

define('DB_CHARSET', 'utf8'); // Database character set
define('DB_COLLATE', ''); // Database collation

\$table_prefix = 'wp_'; // Table prefix for database tables

define('WP_DEBUG', true); // Enable WordPress debugging

// Redis Cache Configuration
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_HOST', 'redis');
define('WP_CACHE', true);

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/'); // Absolute path to the WordPress directory
}

require_once ABSPATH . 'wp-settings.php'; // Include WordPress settings
EOF

sleep 10

# Download WordPress core files
wp --allow-root --path="/var/www/inception/" core download

# Install wordpress if not already installed
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
     wp  --allow-root --path="/var/www/inception/" core install \
          --url=$WP_SITE_URL \
          --title=$WP_TITLE \
          --admin_user=$WP_ADMIN_NAME \
          --admin_password=$WP_ADMIN_PASSWORD \
          --admin_email=$WP_ADMIN_EMAIL
fi;

# Create user if does not exist yet
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER_NAME;
then
     wp  --allow-root --path="/var/www/inception/" user create \
          $WP_USER_NAME \
          $WP_USER_EMAIL \
          --user_pass=$WP_USER_PASSWORD \
          --role=$WP_USER_ROLE
fi;

# Enable Redis Cache after Database is ready
while ! wp db check --allow-root --path=/var/www/inception/; do
    echo "Waiting for Database to be ready..."
    sleep 1
done
wp plugin install redis-cache --activate --allow-root --path=/var/www/inception/
wp redis enable --allow-root --path=/var/www/inception/

# Install and activate the "raft" theme
wp --allow-root --path="/var/www/inception/" theme install raft --activate

# Run next command in Dockerfile
exec $@
