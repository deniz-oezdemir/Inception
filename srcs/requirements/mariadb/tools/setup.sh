#!/bin/bash

# Print all executed commands to terminal for debugging
#set -x

# Start the MariaDB service
service mariadb start

# Create the database and user
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASSWORD_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASSWORD_ROOT');
EOF

# Wait for 5 seconds
sleep 5

# Stop the MariaDB service
service mariadb stop

# Execute the command passed as arguments
exec $@
