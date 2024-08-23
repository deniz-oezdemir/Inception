FROM	debian:11

EXPOSE	443

# Update package lists and install nginx and openssl
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/*

# Define build arguments
ARG		CERTIFICATE_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT DOMAIN_NAME

# Create certificate folder and generate self-signed SSL certificate
RUN		mkdir -p ${CERTIFICATE_FOLDER} && \
		openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-out ${CERTIFICATE} \
		-keyout ${KEY} \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${DOMAIN_NAME}"

# Copy nginx configuration files
COPY	conf/nginx.conf		/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

# Append server configuration details from .env to server.conf
RUN		echo "\tserver_name ${DOMAIN_NAME};\n\
			\tssl_certificate ${CERTIFICATE};\n\
			\tssl_certificate_key ${KEY};\n\
			}" >> /etc/nginx/conf.d/server.conf

# Create directory for web content and set ownership
RUN		mkdir -p /var/www/
RUN		chown -R www-data:www-data /var/www/

# Start nginx in the foreground
CMD		["nginx", "-g", "daemon off;"]
