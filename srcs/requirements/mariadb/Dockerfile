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

# Copy the setup script to the /bin directory and make it executable
COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# Set the entrypoint (for container configuration after it's setup) to run the setup script
ENTRYPOINT	["/bin/setup.sh"]

# Set the default command to run mysqld_safe
CMD			["setup.sh", "mysqld_safe"]
