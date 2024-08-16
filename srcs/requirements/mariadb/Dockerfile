# Inherit from the official Debian image
FROM debian:bullseye

# Set the MySQL database name, password, and user as build arguments - delete before submitting!
ARG MYSQL_DATABASE
ARG MYSQL_PASSWORD
ARG MYSQL_USER

# Set the MySQL database name, password, and user as environment variables - delete before submitting!
ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
ENV MYSQL_USER=$MYSQL_USER

# Set the port for the container to listen on
EXPOSE 3306

# Install MariaDB without any recommended or suggested packages to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests mariadb-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Print the MySQL user for debugging purposes
RUN echo -e "$MYSQL_USER"

RUN service mariadb start

RUN sleep 5

# Create a directory for the MySQL socket file
#RUN mkdir /run/mysqld

# Set executable permissions for the MySQL socket directory
#RUN chmod +x /run/mysqld


# Start the MySQL server, create a database, user, and grant privileges
RUN mysqld --bind-address=0.0.0.0 & \
	sleep 5 && \
	mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" && \
	mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" && \
	mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" && \
	mysql -e "FLUSH PRIVILEGES;"

RUN sleep 5

# Start the MySQL server with the specified bind address
CMD ["mysqld", "--bind-address=0.0.0.0"]
