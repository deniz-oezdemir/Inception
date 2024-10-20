# Inception
Building a small-scale infrastructure with Docker

## Table of Contents
- [Project Overview](#project-overview)
- [Docker and Docker Compose](#docker-and-docker-compose)
- [Docker Image Used with Docker Compose and Without Docker Compose](#docker-image-used-with-docker-compose-and-without-docker-compose)
- [Docker vs. VMs](#docker-vs-vms)
- [Directory Structure](#directory-structure)
- [Configuration Details](#configuration-details)
  - [Setup](#setup)
  - [Network](#network)
  - [NGINX](#nginx)
  - [WordPress](#wordpress)
  - [MariaDB](#mariadb)
  - [Data Persistence](#data-persistence)
- [Bonus](#bonus)
  - [Redis](#redis)
  - [Static website](#static-website)
- [Useful Commands](#useful-commands)
- [Sources](#sources)

## Project Overview
The project aims to build a small-scale infrastructure using Docker. It includes the following components:

- Nginx as the web server
- WordPress as the content management system
- MariaDB as the database server

### Docker and Docker Compose
Docker is a platform that allows you to package applications and their dependencies into containers. Containers are lightweight, portable, and can run on any system that has Docker installed.

Docker Compose is a tool that allows you to define and manage multi-container Docker applications. With Docker Compose, you can use a YAML file to define the services, networks, and volumes for your application, and then start all the services with a single command.

### Docker Image Used with Docker Compose and Without Docker Compose
A Docker image is a standalone, executable package that includes everything needed to run a piece of software. When used with Docker Compose, images are defined in a `docker-compose.yml` file along with their configurations, dependencies, and networks. This allows you to manage and orchestrate multiple containers as a single application. Without Docker Compose, you would need to manually start and link each container using individual Docker commands, which can be more complex and error-prone.

### Docker vs. VMs
Docker containers are more lightweight and efficient compared to virtual machines (VMs). Containers share the host system's kernel and resources, which reduces overhead and allows for faster startup times.

VMs, on the other hand, require a full operating system for each instance, which consumes more resources and takes longer to boot.

Docker also provides better portability and consistency, as containers can run on any system with Docker installed, ensuring that applications behave the same in different environments.

![Docker vs VM](./Docker%20vs%20VM.png)

### Directory Structure
The directory structure for this project is designed to organize the different components and configurations in a clear and maintainable way. For example, having separate directories for Nginx, WordPress, and MariaDB configurations helps to keep related files together and makes it easier to manage and update them. This structure also aligns with best practices for Docker projects, ensuring that each service has its own context and build configuration, which improves modularity and reusability.

## Configuration Details

### Setup
- Nginx port 443 only: check file server.conf
- SSL/TLS:
    - browser - lock in address bar - connection not secure - more information - technical details - ... TLS 1.3 ... (/View Certificate)
    - `openssl s_client -connect denizozd.42.fr:443` - check "SSL-session"
- Docker images name: check in docker-compose.yml for "image: <name>" or after starting services use: `docker ps --format "table {{.Names}}\t{{.Image}}"` or `docker ps`
- docker compose: Makefile - docker compose or Error

### Network
The Docker network used for this setup is named `inception_net` and is configured as a bridge network. It allows communication between the containers and assigns unique IPv4 addresses to each container within the network's subnet.

- docker-compose.yml: section "networks"
- `docker network ls` output:
    - bridge: default network driver in Docker. Containers connected to this network can communicate with each other. Provides network isolation.
    - host: removes network isolation between the container and the Docker host. Containers using the host network can directly access the host's networking stack.
    - inception_net (docker compose automatically prefixes the network name with the project name): custom bridge network, created for this Inception project. It allows containers connected to it to communicate with each other, and it might be configured with specific settings for your project.
    - none: provides no networking for the containers. It's used when you don't want the container to have any network access.

`docker network inspect inception_net`: The Docker network used for this setup is named `inception_net`, configured as a bridge network. It contains three containers: `mariadb`, `wordpress`, and `nginx`, each assigned a unique IPv4 address within the network's subnet.
- mariadb serves as the database server
- wordpress functions as the content management system
- nginx acts as the web server that forwards requests to wordpress

![Network Topology](./Network%20Topology.png)

Data flow when accessing via a web browser:
1. Send a request to `https://localhost` (port 443).
2. Nginx forwards the request to WordPress.
3. WordPress handles the request, which may involve querying the MariaDB.
4. The response is sent back through the network, reaching Nginx, which forwards it back to the browser.

### NGINX
- port 80:  http://localhost (should not work)
- port 443: https://localhost (should work)

### WordPress
- volumes created in Makefile
- `docker volume ls`
- `docker volume inspect <volume name>`: check "device:"
- login via: https://localhost/wp-login.php
- if cookies blocked: security - add exception - reload page
- add comment: login - sidebar "Comments" - got to post with enabled comments - add comment
- add page: login - sidebar "Pages" - Add New Page - edit page - "Publish"

### MariaDB
Access database:
- `docker ps -a`
- `docker exec -it <copiedID> mysql -u <username> -p`
- `SHOW DATABASES;`
- `USE <database_name>;`
- `SHOW TABLES;`
- e.g., `SELECT * FROM wp_comments;`

### Data Persistence
- `Ctrl + c` to stop containers
- `sudo reboot`
- login
- `make`
- check e.g. created pages, comments, etc.

## Bonus

### Redis
- Redis is used as a database, cache, and message broker.
- It stores data in memory, making it faster than traditional disk-based databases.
- Redis is a key-value store, storing data in a dictionary-like structure.
- It is great for caching, as it can store data in memory and retrieve it quickly.
- In this project, we will build a Redis container and use it to cache API requests.
- Caching requests will make the application faster by reducing the number of database queries.

- Verify Redis is running with `redis-cli`:
  - `docker exec -it redis redis-cli`
  - `MONITOR`
- Edit or add content on your WordPress site to see logs in the terminal. If logs appear, Redis is capturing database requests, indicating it's working as a cache.
- Check Redis info or keys:
  - `docker exec -it redis redis-cli`
  - `INFO`
  - `KEYS *`

### Static website
- Static website hosted by nginx as a new server can be accessed via `http://dog.42.fr:8080/` and `http://localhost:8080/`.

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

In case of too little space
- stop and remove images, volumes, network with `docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null`
- check disk space usage with `df -h`
- clean stopped containers, dangling images, build cache with `docker system prune -a --volumes`

## Sources

[Tutorial for the mandatory part](https://github.com/waltergcc/42-inception/blob/main/README.md)

[Tutorial for the bonus part](https://github.com/caroldaniel/42sp-cursus-inception/blob/main/guides/Bonus-en.md)

[Containers vs. VMs](https://www.netapp.com/blog/containers-vs-vms/)

[Hostsed](https://github.com/socrateslee/hostsed)

[Secrets vs. .env](https://stackoverflow.com/questions/44615837/why-is-docker-secrets-more-secure-than-environment-variables)
