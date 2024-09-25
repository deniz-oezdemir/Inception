FROM	debian:bullseye

# Expose port 9000 as in subject's diagram
EXPOSE	9000

# Set the default PHP path
ARG		PHPPATH=/etc/php/7.4/fpm

# Update and install necessary packages
RUN		apt update && apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		php7.4-fpm \
		php7.4-mysql \
		wget \
		tar && \
		rm -rf /var/lib/apt/lists/*

# Stop the php7.4-fpm service to change it's configuration
RUN		service php7.4-fpm stop

# Copy the PHP configuration file
COPY	conf/www.conf ${PHPPATH}/pool.d/

# Modify the php configuration and www.conf files
# sed -i: stream edit in place
# 1. do not allow PHP to interpret part of URL as file path
# 2. configure PHP-FPM (FastCGI Process Manager) to listen on port 9000 instead of Unix socket
# 3. remove comment (;) making listen active
# 4. run PHP-FPM in foregound
RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

# Download and install WP-CLI
RUN		wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# Create necessary directories
RUN		mkdir -p /run/php/ && \
		mkdir -p /var/run/php/ && \
		mkdir -p /var/www/inception/

# Set ownership of /var/www/inception/ directory
RUN		chown -R www-data:www-data /var/www/inception/

# Copy the setup_wp.sh script to /bin/ and make it executable
COPY	tools/setup_wp.sh /bin/
RUN		chmod +x /bin/setup_wp.sh

# Execute the script, start the php server, set server to not run in background
CMD		["setup_wp.sh", "php-fpm7.4", "--nodaemonize"]
