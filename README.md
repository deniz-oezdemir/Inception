# Inception
Building a small-scale infrastructure with Docker

## Project Overview
The project aims to build a small-scale infrastructure using Docker. It includes the following components:

- Nginx: Acts as the web server and forwards requests to WordPress.
- WordPress: Functions as the content management system.
- MariaDB: Serves as the database server.

The Docker network used for this setup is named `inception_all` and is configured as a bridge network. It allows communication between the containers and assigns unique IPv4 addresses to each container within the network's subnet.

To access the application, use the following URLs:
- Port 80: http://localhost
- Port 443: https://localhost

## Configuration Details

#### Setup
- Nginx port 443 only: check file server.conf
- SSL/TLS: browser - lock in address bar - connection not secure - more information - technical details - ... TLS 1.3 ... (/View Certificate)
- Docker images name: check in docker-compose.yml for "image: <name>" or after starting services use: `docker ps --format "table {{.Names}}\t{{.Image}}"` or `docker ps`
- docker compose: Makefile - docker compose or Error

#### Network
- docker-compose.yml: section "networks"
- `docker network ls` output:
    - bridge: default network driver in Docker. Containers connected to this network can communicate with each other. Provides network isolation.
    - host: removes network isolation between the container and the Docker host. Containers using the host network can directly access the host's networking stack.
    - inception_all (docker compose automatically prefixes the network name with the project name): custom bridge network, likely created for your Inception project. It allows containers connected to it to communicate with each other, and it might be configured with specific settings for your project.
    - none: provides no networking for the containers. It's used when you don't want the container to have any network access.

`docker network inspect inception_all`: The Docker network used for this setup is named `inception_all`, configured as a bridge network. It contains three containers: `mariadb`, `wordpress`, and `nginx`, each assigned a unique IPv4 address within the network's subnet.
- mariadb serves as the database server
- wordpress functions as the content management system
- nginx acts as the web server that forwards requests to wordpress

![Network Topology](./Network%20Topology.png)

Data flow when accessing via a web browser:
1. Send a request to `https://localhost` (port 443).
2. Nginx forwards the request to WordPress.
3. WordPress handles the request, which may involve querying the MariaDB.
4. The response is sent back through the network, reaching Nginx, which forwards it back to the browser.

#### NGINX
- port 80:  http://localhost
- port 443: https://localhost

#### WordPress
- volumes created in Makefile
- `docker volume ls`
- `docker volume inspect <volume name>`: check "device:"
- login via: https://localhost/wp-login.php
- if cookies blocked: security - add exception - reload page
- add comment: login - sidebar "Comments" - got to post with enabled comments - add comment
- add page: login - sidebar "Pages" - Add New Page - edit page - "Publish"

#### MariaDB
Access database:
- `docker ps -a`
- `docker exec -it <copiedID> mysql -u <username> -p`
- `SHOW DATABASES;`
- `USE <database_name>;`
- `SHOW TABLES;`
- e.g., `SELECT * FROM wp_comments;`

#### Data Persistence
- `Ctrl + c` to stop containers
- `sudo reboot`
- login
- `make`
- check e.g. created pages, comments, etc.

## Useful Commands
In e.g. the `wordpress` directory:
- `docker build -t wordpress .`: build a Docker image with the tag "wordpress"
- `docker run -d wordpress`: run a container based on the "wordpress" image in detached mode
- `docker ps -a`: display the status of all containers, including the ones that are not running
- `docker exec -it <copiedID> /bin/bash`: execute an interactive shell inside a running container
- `docker rm -f $(docker ps -aq) &&  docker rmi -f $(docker images -aq)`: remove all containers and images

In the directory containing the `docker-compose.yml` file:
- `systemctl status docker`: check if Docker is running on your system
- `docker compose up`: start the containers defined in your Docker Compose file
- `docker compose ps`: display the status of the containers defined in your Docker Compose file
- docker stop
- docker rm
- `docker compose down`: stop and remove the containers defined in your Docker Compose file
- `docker compose down -v`: stop and remove the containers defined in your Docker Compose file, as well as remove any associated volumes

## Sources

[Tutorial](https://github.com/waltergcc/42-inception?tab=readme-ov-file#1-the-containers)
