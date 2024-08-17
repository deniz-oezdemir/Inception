# Inception
Building a small-scale infrastructure with Docker

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

# Sources

https://github.com/waltergcc/42-inception?tab=readme-ov-file#1-the-containers

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
