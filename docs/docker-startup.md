# Container Startup Customization

This guide explains how to add custom commands that run every time a container starts.

## Overview

The dotfiles image includes a startup script mechanism that allows you to run commands on each container start (not just the first initialization). This can be useful for things like:

- Starting project-specific services (databases, web servers, etc.)
- Setting up dynamic environment variables
- Running health checks
- Starting background processes
- Checking external resource availability

## The Startup Script

The startup script is located at `~/.local/bin/container-startup.sh` and is managed by chezmoi. It is **sourced** automatically every time the container starts as part of the container's entrypoint.

Because it is sourced:
1. Environment variables exported in this script (`export MY_VAR=value`) will be available in your shell.
2. **Do not use `exit`** in this script, or the container will stop immediately.
3. If a command fails (returns non-zero), the container may exit immediately due to `set -e`.

## Customization Methods

### Method 1: Edit via Chezmoi (Recommended for Personal Defaults)

Edit the script through chezmoi for changes that apply to all your containers:

```bash
# Edit the startup script
chezmoi edit ~/.local/bin/container-startup.sh

# Apply changes
chezmoi apply
```

> **Note:** Changes only take effect on the next container start, but can also be applied immediately by sourcing the script manually: `. container-startup.sh`

This approach:
- ✅ Version controlled
- ✅ Applies to all containers using your dotfiles
- ✅ Syncs across machines
- ❌ Requires chezmoi apply to take effect

### Method 2: Volume Mount (Recommended for Project-Specific Commands)

Mount a project-specific startup script for per-container customization:

```bash
# Create a project-specific startup script
cat > my-project-startup.sh << 'EOF'
#!/bin/sh
echo "Starting project services..."
# Start your services here
EOF

chmod +x my-project-startup.sh

# Run container with the custom startup script
docker run -it \
  -v "$(pwd)/my-project-startup.sh:/home/guest/.local/bin/container-startup.sh:ro" \
  timosutterer/dotfiles
```

This approach:
- ✅ Different commands per container/project
- ✅ No rebuild required
- ✅ Keep project-specific logic with the project
- ❌ Need to mount on every `docker run`

### Method 3: Direct Modification (Recommended for Quick Experiments)

Simply edit the file inside a running container:

```bash
# Inside the container
v ~/.local/bin/container-startup.sh
# Add your commands
```

> **Note:** Changes only take effect on the next container start, but can also be applied immediately by sourcing the script manually: `. container-startup.sh`

This approach:
- ✅ Fastest for quick experiments
- ✅ No external files needed
- ❌ Changes are lost if the container is deleted
- ❌ Not version controlled

## Container Lifecycle

The startup script runs:
- ✅ On `docker run`
- ✅ On `docker start` (restarting a stopped container)
- ❌ NOT on `docker exec` (only when starting the main process)

## Comparison with Other Approaches

| Approach | Runs When | Use Case |
|----------|-----------|----------|
| Startup script | Every container start | Services, dynamic setup |
| `run_once_*` | First chezmoi apply | One-time installation |
| `run_onchange_*` | When script changes | Tool updates |
| Dockerfile RUN | Image build | Baked-in software |
