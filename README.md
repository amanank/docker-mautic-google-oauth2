# Mautic Docker Setup with Google OAuth2 for Sending Emails

This repository contains a Docker setup for Mautic, which supports Google OAuth2 for sending emails. It is based on the official Mautic setup with a few changes to enable Google OAuth2.

## Changes Made

1. **Composer Installation in Builder Image**: Composer is installed in the builder image to install the `symfony/google-mailer` package.
2. **Google Mailer Patch**: A patch is applied to the Google Mailer to correctly generate the password by using the refresh token to get an access token.

## Prerequisites

Before you begin, ensure you have the following:

1. **Docker and Docker Compose**: Make sure Docker and Docker Compose are installed on your machine. You can download them from the [Docker website](https://www.docker.com/products/docker-desktop).
2. **Google OAuth2 Credentials**: Generate the Google OAuth2 Client ID, Client Secret, and Refresh Token using the [Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground).
3. **Docker Network**: Ensure that the `NETWORK_NAME` configured in the `.env` file exists. You can create it using the following command:
    ```sh
    docker network create NETWORK_NAME
    ```
4. **MySQL Container**: Make sure the MySQL container is running on the same network with the name configured under `MYSQL_HOST` in the `.env` file. You can start the MySQL container with the following command:
    ```sh
    docker run --name MYSQL_HOST --network NETWORK_NAME -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
    ```
5. **Database and User**: Once the MySQL container is running, create the database and user for Mautic. You can do this by running the following SQL script, replacing the database name, user name, and password with those configured in the `.env` file:
    ```sql
    docker exec -i MYSQL_HOST mysql -uroot -proot <<EOF
    CREATE DATABASE mautic;
    CREATE USER 'mauticuser'@'%' IDENTIFIED BY 'mauticpassword';
    GRANT ALL PRIVILEGES ON mautic.* TO 'mauticuser'@'%';
    FLUSH PRIVILEGES;
    EOF
    ```

## Setup Instructions

1. **Clone the Repository**:
    ```sh
    git clone git@github.com:amanank/docker-mautic-google-oauth2.git
    cd docker-mautic-google-oauth2
    ```

2. **Create and Update Environment Variables**: Copy the `.env.example` file to `.env`:
    ```sh
    cp .env.example .env
    ```
    Then, update the `.env` file with your Google OAuth2 credentials and other necessary configurations.

3. **Build and Run the Docker Containers**:
    ```sh
    docker compose up -d
    ```

4. **Access Mautic**: Once the containers are up and running, you can access Mautic at `http://<your-site-host>`.

## Configuration Files

- **`conf/local.php`**: Contains the database and mailer configurations.
- **`conf/php.ini`**: PHP configuration file.
- **`conf/supervisord.conf`**: Configuration for Supervisor to manage Mautic worker processes.
- **`conf/google-mailer-patcher.sh`**: Shell script to patch the Google Mailer.

## Dockerfile

The `Dockerfile` is set up to:

1. Install necessary PHP extensions.
2. Install Composer.
3. Create a Mautic project.
4. Install the `symfony/google-mailer` package.
5. Apply the Google Mailer patch.
6. Set up the final image with the necessary configurations and entry point.

## `docker-compose.yml`

The `docker-compose.yml` file defines the Mautic service, including environment variables, volumes, and health checks.

## Additional Information

- **Volumes**: The setup includes volumes to persist data for Mautic configurations, logs, and media.
- **Entrypoint**: The `docker-entrypoint.sh` script ensures the correct permissions and waits for the database to be ready before starting Mautic.

For more details, refer to the individual configuration files and scripts in the repository.

## Common Issues

### Problem: Error when trying to send test email
**Error Message**: Unknown DSN scheme. Please make sure the mailer DSN is configured properly.

**Solution**: Empty the cache in `/var/www/html/cache/` using the following command:
```sh
docker exec -it mautic rm -rf /var/www/html/cache/*
```

For more details, refer to the individual configuration files and scripts in the repository.