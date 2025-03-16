# Running a Container

This guide provides practical examples for running Docker containers with the dotfiles image. For basic Docker command explanations, see [Docker Basics](docker-basics.md).

## Quick Start

```bash
docker run -it timosutterer/dotfiles
```

## Common Workflows

### Development Container with Mounted Volumes

Mount your projects directory to work on host files from within the container:

```bash
docker run -it \
  --name dev-environment \
  -v /home/$(whoami)/Projects:/home/$(whoami)/Projects \
  timosutterer/dotfiles
```

> **Note:** When using volume mounts, be aware of the implications. See [Important Notes on Volume Mounts](docker-mounts.md).

### Using Docker from Within a Container

To use Docker commands inside the container that interact with the host Docker daemon:

```bash
docker run -it \
  --name docker-in-docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  timosutterer/dotfiles
```

> **Note:** This gives the container access to your host's Docker daemon. Be careful with permission implications.

### Complete Development Environment

A full-featured development container with timezone, hostname, Docker access and mounted directories:

```bash
docker run \
  -it \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /home/$(whoami)/Projects:/home/$(whoami)/Projects \
  -e TZ=Europe/Amsterdam \
  --name dotfiles-dev \
  --hostname dotfiles-dev \
  timosutterer/dotfiles
```

> **Note:** See [Important Notes on Volume Mounts](docker-mounts.md) for information about volume mount implications.

### Working with Container Names and Hostnames

```bash
# Start a container with a specific name and hostname
docker run -it --name frontend-dev --hostname frontend timosutterer/dotfiles

# Rename a container (after exiting)
docker rename frontend-dev backend-dev

# Resume work with the renamed container
docker start -ai backend-dev
```

> **Note:** While you can rename a container, you cannot change its internal hostname after creation.

## Port Mapping

Map ports to access services running inside the container from your host:

```bash
# Map a single port (host:container)
docker run -it -p 3000:3000 timosutterer/dotfiles

# Map multiple ports
docker run -it -p 3000:3000 -p 8080:80 timosutterer/dotfiles

# Map to a random host port
docker run -it -p 3000 timosutterer/dotfiles

# Map to specific interface on host
docker run -it -p 127.0.0.1:3000:3000 timosutterer/dotfiles
```

### Port Mapping Considerations

- **Security**: Exposed ports are accessible from outside your machine unless restricted with an interface (e.g., `127.0.0.1:3000:3000`)
- **Conflicts**: Cannot map multiple containers to the same host port simultaneously
- **Services**: Common ports to consider mapping:
  - Web servers: 80, 443, 8080, 3000
  - Databases: 5432 (PostgreSQL), 3306 (MySQL), 27017 (MongoDB)

## Working with Mounted Volumes

For detailed information about volume mounts, permissions, ownership, and best practices, see [Important Notes on Volume Mounts](docker-mounts.md).

### Mount Types

```bash
# Bind mount (host directory to container)
docker run -it -v /host/path:/container/path timosutterer/dotfiles

# Named volume (persistent data managed by Docker)
docker run -it -v data-volume:/container/path timosutterer/dotfiles

# Read-only mount
docker run -it -v /host/path:/container/path:ro timosutterer/dotfiles
```

## Container Lifecycle Management

### Persistent Container Workflow

**Start a named container**:

```bash
docker run -it --name dotfiles-dev timosutterer/dotfiles
```

**Resume your work** (after the container has been stopped):

```bash
docker start -ai dotfiles-dev
```

> **Note:** This assumes the container `dotfiles-dev` exists but has been stopped using `docker stop dotfiles-dev` or by exiting the shell.

**Alternative: Attach to a running container** (if the container is still running):

```bash
docker attach dotfiles-dev
```

> **Important:** When using `docker attach`:
>
> - You can attach from any terminal/machine that has access to the Docker daemon
> - Multiple terminal sessions can attach to the same container
> - All attached sessions will receive the same input/output
> - Detaching requires a specific key sequence (Ctrl+P, Ctrl+Q) instead of just exiting the shell
> - If you exit the shell in one attached session, the container will stop and all other sessions will be disconnected
> - For independent terminal sessions to the same container, use `docker exec -it dotfiles-dev zsh` instead

**Run a quick command without attaching**:

```bash
docker exec dotfiles-dev git status
```

### Ephemeral Usage Workflow

**Use a container temporarily and discard it after use**:

```bash
docker run -it --rm timosutterer/dotfiles
```

### Background Container Workflow

**Start a container in the background**:

```bash
docker run -d --name dotfiles-daemon timosutterer/dotfiles sleep infinity
```

> **Note:** The `-d` flag requires a long-running command that doesn't exit immediately. The `sleep infinity` command keeps the container running, as the default `zsh` command would exit if not connected to a terminal. Without such a long-running process, a container started with `-d` would start and then immediately stop.

**Execute commands in it as needed**:

```bash
docker exec -it dotfiles-daemon zsh
```

**Stop when done**:

```bash
docker stop dotfiles-daemon
```

## Copying Files Between Host and Container

### Using the `docker cp` Command

The `docker cp` command allows you to copy files or directories between a container and the local filesystem:

**Copy a configuration file to a running container**:

```bash
docker cp ~/.vimrc dotfiles-dev:/home/$(whoami)/.vimrc
```

**Copy a project from a container to your host**:

```bash
docker cp dotfiles-dev:/home/$(whoami)/Projects/myproject ./myproject-backup
```

**Copy directory contents including hidden files from host to container**:

```bash
docker cp ~/.config/. dotfiles-dev:/home/$(whoami)/.config/
```

> **Important:** When using `docker cp`:
>
> - Files copied with `docker cp` will inherit the ownership of the destination directory by default.
> - `docker cp` follows symbolic links from the source.

### Using `tar` for Efficient Transfers

For transferring multiple files or preserving permissions:

```bash
# Pack on host and extract in container
tar -czf - -C /path/to/source . | docker exec -i container_name tar -xzf - -C /destination

# Pack in container and extract on host
docker exec -i container_name tar -czf - -C /source . | tar -xzf - -C /path/to/destination
```
