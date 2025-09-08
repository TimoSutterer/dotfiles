# dotfiles

## Quick Start

With [chezmoi](https://github.com/twpayne/chezmoi) installed:

```
chezmoi init -a TimoSutterer
```

On a new machine:

```
sh -c "cd $HOME && $(curl -fsLS get.chezmoi.io)" -- init --apply TimoSutterer
```

[Containerized](https://hub.docker.com/r/timosutterer/dotfiles):

```
docker run -it timosutterer/dotfiles
# Configure chezmoi variables (optional)
chezmoi init -a
```

## Usage Guide

For more detailed usage information and advanced customization options, see the [full documentation](docs/README.md).

## Troubleshooting

### Display Issues

If colors or symbols don't render correctly in your terminal, see the [Powerlevel10k troubleshooting guide](docs/p10k-troubleshooting.md) for font installation and display configuration help.

### Keyboard Shortcut Issues

If you're experiencing issues with keyboard shortcuts (e.g. Ctrl+P) in Docker containers, see the [Docker troubleshooting guide](docs/docker-troubleshooting.md) for solutions.
