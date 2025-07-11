# Quick reference

- **GitHub**: [TimoSutterer/dotfiles](https://github.com/TimoSutterer/dotfiles)
- **Latest Release**: [v{{LATEST_VERSION}}](https://github.com/TimoSutterer/dotfiles/releases/tag/v{{LATEST_VERSION}})

# Supported tags and respective `Dockerfile` links

- [`{{LATEST_VERSION}}`, `{{MAJOR_MINOR}}`, `{{MAJOR}}`, `latest`](https://github.com/TimoSutterer/dotfiles/blob/v{{LATEST_VERSION}}/Dockerfile)

For previous versions, see the [GitHub releases page](https://github.com/TimoSutterer/dotfiles/releases).

# What is this image?

This Docker image provides a standardized development environment with a carefully curated set of dotfiles, tools, and configurations. It's designed to offer a consistent experience across different machines and platforms.

# How to use this image

```bash
# Run with latest version
docker run -it timosutterer/dotfiles:latest

# Run with specific semantic version
docker run -it timosutterer/dotfiles:{{LATEST_VERSION}}

# Run with major.minor version (automatically uses latest patch version)
docker run -it timosutterer/dotfiles:{{MAJOR_MINOR}}

# Run with major version only (automatically uses latest minor.patch version)
docker run -it timosutterer/dotfiles:{{MAJOR}}
```

Once inside the container, you can configure chezmoi variables:

```bash
# Optional: Configure chezmoi with your personal variables
chezmoi init -a
```

For detailed configuration instructions and available customization options, please visit the [GitHub repository](https://github.com/TimoSutterer/dotfiles).

# Troubleshooting

If colors or symbols don't render correctly, see the [Powerlevel10k troubleshooting guide](https://github.com/TimoSutterer/dotfiles/blob/main/docs/p10k-troubleshooting.md) for font installation and display configuration help.
