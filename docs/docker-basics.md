# Docker Basics

This guide explains essential Docker commands and flags. For detailed examples and workflows, see [Running Containers](docker-run.md).

## Common Commands

### `docker run`

Creates and starts a new container from an image.

```bash
docker run -it timosutterer/dotfiles
```

Common flags:

- `-i` (interactive): Keeps STDIN open
- `-t` (tty): Allocates a pseudo-TTY, giving you a terminal
- `-d` (detached): Runs container in the background
- `--rm`: Automatically removes the container when it exits
- `-v`: Mounts a volume (e.g., `-v /host/path:/container/path`) - see [Important Notes on Volume Mounts](docker-mounts.md)
- `-p`: Maps ports (e.g., `-p 8080:80` maps host port 8080 to container port 80)
- `-e`: Sets environment variables (e.g., `-e TZ=Europe/Amsterdam`)
- `--name`: Assigns a name to your container
- `--hostname`: Sets the internal hostname of the container

### `docker start`

Starts an existing stopped container.

```bash
docker start -ai my-container
```

Common flags:

- `-a` (attach): Attaches STDOUT/STDERR
- `-i` (interactive): Attaches STDIN

### `docker exec`

Runs a command in an already running container.

```bash
docker exec -it my-container zsh
```

Common flags:

- `-i` (interactive): Keeps STDIN open
- `-t` (tty): Allocates a pseudo-TTY

### `docker rm`

Removes one or more containers.

```bash
docker rm my-container
```

Common flags:

- `-f` (force): Force remove a running container
- `-v`: Remove volumes attached to the container

### `docker rename`

Renames a container.

```bash
docker rename old-name new-name
```

> **Note:** This only changes the container name, not its internal hostname. The hostname is set at container creation and cannot be changed.

## Other Useful Commands

- `docker ps`: List running containers
- `docker ps -a`: List all containers (including stopped ones)
- `docker images`: List available images
- `docker volume ls`: List volumes
- `docker network ls`: List networks

For common workflow examples and advanced usage patterns, see [Running Containers](docker-run.md).
