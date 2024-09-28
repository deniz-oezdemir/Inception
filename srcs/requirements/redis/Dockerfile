# Inherit from the official Debian image
FROM	debian:11

# Set default port for redis container
EXPOSE	6379

# Update and upgrade system & install Redis
RUN		apt -y update && apt -y upgrade
RUN		apt -y install redis-server redis-tools

# Create PID directory for Redis
RUN		mkdir -p /run/redis
RUN		chmod 755 /run/redis

# Make backup of config and change config to listen from any host as wordpress is in another container
RUN		cp /etc/redis/redis.conf /etc/redis/redis.conf.bak
RUN		sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/' /etc/redis/redis.conf

# Run Redis
ENTRYPOINT	[ "redis-server", "--protected-mode", "no" ]
