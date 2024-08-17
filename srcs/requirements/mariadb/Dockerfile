# Inherit from the official Debian image
FROM	debian:bullseye

# Set the port for the container to listen on
EXPOSE	3306

# Install MariaDB without any recommended or suggested packages to reduce image size
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

ENTRYPOINT ["/bin/setup.sh"]

CMD		["setup.sh", "mysqld_safe"]
