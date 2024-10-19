# Inception

## Summary
Inception is a project aimed at building a small-scale infrastructure using Docker. It utilizes the LEMP stack, which includes the following components.

## Components
- **Linux**: The base operating system for all containers.
- **Nginx**: The web server that handles HTTP and HTTPS requests.
- **MariaDB**: The database server used to store and manage data.
- **PHP**: The scripting language used by WordPress for dynamic content.

![Network Topology](./Network%20Topology.png)

## Bonus Components
- **Redis**: Used as a caching layer to improve performance by reducing the number of database queries.
- **Static Website**: Hosted by Nginx and accessible via `http://dog.42.fr:8080/` and `http://localhost:8080/`.

## Installation and Usage
To set up the project, follow these steps:

1. **Clone the repository**:
    ```sh
    git clone https://github.com/deniz-oezdemir/Inception
    cd Inception
    ```

2. **Build and start the containers**:
    ```sh
    make
    ```

3. **Access the services**:
    - WordPress: `https://localhost` or login via `https://localhost/wp-login.php`
    - Static Website: `http://dog.42.fr:8080/` or `http://localhost:8080/`

## Useful Commands
- `docker compose up`: Start the containers.
- `docker compose ps`: Display the status of the containers.
- `docker compose down`: Stop and remove the containers.

For more detailed information, refer to the [Evaluation README.md](Evaluation%20README.md).
