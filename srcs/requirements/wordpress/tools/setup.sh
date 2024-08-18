#!/bin/bash

# Change ownership of /var/www/inception/ directory to www-data user and group
chown -R www-data:www-data /var/www/inception/

# Move wp-config.php file to /var/www/inception/ directory if it doesn't exist
if [ ! -f "/var/www/inception/wp-config.php" ]; then
    mv /tmp/wp-config.php /var/www/inception/
fi

sleep 10

# Download WordPress core files
wp --allow-root --path="/var/www/inception/" core download || true

# Check if WordPress is already installed
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
     # Install WordPress
     wp  --allow-root --path="/var/www/inception/" core install \
          --url=$WP_SITE_URL \
          --title=$WP_TITLE \
          --admin_user=$WP_ADMIN_NAME \
          --admin_password=$WP_ADMIN_PASSWORD \
          --admin_email=$WP_ADMIN_EMAIL
fi;

# Check if the specified user exists
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER_NAME;
then
     # Create a new user
     wp  --allow-root --path="/var/www/inception/" user create \
          $WP_USER_NAME \
          $WP_USER_EMAIL \
          --user_pass=$WP_USER_PASSWORD \
          --role=$WP_USER_ROLE
fi;

# Install and activate the "raft" theme
wp --allow-root --path="/var/www/inception/" theme install raft --activate

# Run next command in Dockerfile
exec $@
