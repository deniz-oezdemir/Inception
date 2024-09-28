NAME		= inception
HOST_URL	= denizozd.42.fr

# Create directories for mariadb and WordPress files
# Add a host entry to redirect the HOST_URL to 127.0.0.1 loopback adress (allows to access local web server in browser - no external access)
# Start the containers using docker-compose
up:
	sudo mkdir -p ~/data/mariadb_data
	sudo mkdir -p ~/data/wordpress_data
	echo "127.0.0.1 $(HOST_URL)" | sudo tee -a /etc/hosts
	docker compose -p $(NAME) -f ./srcs/docker-compose.yml up --build

# Remove the host entry for HOST_URL
# Stop and remove the containers
down:
	sudo sed -i "/127.0.0.1 $(HOST_URL)/d" /etc/hosts
	docker compose -p $(NAME) down

# Remove all data (Caution)
clean: down
	docker compose -f srcs/docker-compose.yml rm -f
	docker compose -f srcs/docker-compose.yml down --rmi all
	sudo rm -rf ~/data/mariadb_data
	sudo rm -rf ~/data/wordpress_data

# Clean stopped containers, dangling images, build cache
prune: clean
	docker system prune -a --volumes -f
