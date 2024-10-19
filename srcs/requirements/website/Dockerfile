FROM		debian:11

EXPOSE	8080

# Create the working directory
RUN			mkdir -p /var/www/website

# Set the working directory
WORKDIR	/var/www/website

# Copy the website source code
COPY		./srcs/* /var/www/website/

# Install busybox
RUN			apt update && apt install -y busybox

# Start busybox HTTP server
CMD			["busybox", "httpd", "-f", "-p", "8080"]
