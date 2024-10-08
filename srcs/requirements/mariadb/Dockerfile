# Inherit from the official Debian image
FROM	debian:11

# Set the port for the container to listen on as in subject
EXPOSE	3306

# Install MariaDB without any recommended or suggested packages to reduce image size
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

# Copy the server configuration file
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy the setup_db.sh script to the /bin directory and make it executable
COPY	tools/setup_db.sh /bin/
RUN		chmod +x /bin/setup_db.sh

# Set the entrypoint (for container configuration after it's setup_db.sh) to run the setup_db.sh script
ENTRYPOINT	["/bin/setup_db.sh"]

# Set the default command to run mysqld_safe
CMD			["setup_db.sh", "mysqld_safe"]
