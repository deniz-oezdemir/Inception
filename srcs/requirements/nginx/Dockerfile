# Get debian 11 for base image
FROM debian:bullseye

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y nginx openssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=DE/ST=Berlin/L=Berlin/O=42_Berlin/OU=Student/CN=denizozd"

# Copy custom nginx configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
