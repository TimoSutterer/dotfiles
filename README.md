# dotfiles

## Quick Start

With [chezmoi](https://github.com/twpayne/chezmoi) installed:

```
chezmoi init -a TimoSutterer
```

On a new machine:

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply TimoSutterer
```

[Containerized](https://hub.docker.com/r/timosutterer/dotfiles):

```
docker run -it timosutterer/dotfiles
# Configure chezmoi variables (optional)
chezmoi init -a
```

## Usage Guide

For more detailed usage information and advanced customization options, see the [full documentation](docs/README.md).
