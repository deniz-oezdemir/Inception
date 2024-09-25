#!/bin/bash

# Read passwords from files
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_PASSWORD_ROOT=$(cat /run/secrets/db_password_root)

service mariadb start

# Create the database and user
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASSWORD_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASSWORD_ROOT');
EOF

sleep 5

service mariadb stop

# Execute the command passed as arguments
exec $@
