NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= denizozd.42.fr

all: $(NAME)

$(NAME): up

# Create directories for database and WordPress files
# Add a host entry to redirect the HOST_URL to 127.0.0.1 loopback adress (allows to access local web server in browser - no external access)
# Start the containers using docker-compose
up:
	mkdir -p ~/data/database
	mkdir -p ~/data/wordpress_files
	sudo hostsed add 127.0.0.1 $(HOST_URL)
	docker compose -p $(NAME) -f $(COMPOSE) up --build || (echo " $(FAIL)" && exit 1)

# Remove the host entry for HOST_URL
# Stop and remove the containers
down:
	sudo hostsed rm 127.0.0.1 $(HOST_URL)
	docker compose -p $(NAME) down
