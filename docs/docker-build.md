# Building Custom Docker Images

## Quick Build

Builds a Docker image from the current directory using default settings and tags it as "dotfiles" for easy reference:

```bash
docker build -t dotfiles .
```

> **Note:** This command uses the local Dockerfile, but still fetches the dotfiles from the TimoSutterer/dotfiles GitHub repo. See [Using Local Repository](#using-local-repository) below for how to use your local dotfiles repository as well.

## Customizing the Build

### Using Local Repository

To use the local repository instead of fetching from GitHub, set the `CHEZMOI_REPO` build argument to an empty string:

```bash
docker build --build-arg CHEZMOI_REPO= -t dotfiles .
```

### Available Build Arguments

```bash
docker build \
  --build-arg USERNAME=$(whoami) \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) \
  --build-arg NODE_VERSION=22.11.0 \
  --build-arg NVIM_VERSION=v0.11.2 \
  --build-arg DELTA_VERSION=0.18.2 \
  --build-arg CHEZMOI_REPO=TimoSutterer \
  -t dotfiles .
```

- **USERNAME** - Container username
- **USER_UID** - User ID
- **USER_GID** - Group ID
- **NODE_VERSION** - Node.js version to install
- **NVIM_VERSION** - Neovim version to install
- **DELTA_VERSION** - Delta version to install
- **CHEZMOI_REPO** - GitHub repo for chezmoi, use empty string for [local repository](#using-local-repository)

> **Important:** Setting the USERNAME, USER_UID, and USER_GID is particularly important when mounting directories from your host system. Learn more about [Docker Mounts and Permissions](docker-mounts.md).

See the [Dockerfile](/Dockerfile) for default values of these build arguments and more details on the image configuration.
