# Docker Troubleshooting Guide

## Ctrl+P Keyboard Shortcut Not Working in Docker Containers

### Problem
Inside a Docker container, the Ctrl+P keyboard shortcut doesn't work as expected. The keystroke seems to be "eaten" or ignored on first press.

### Root Cause
Docker uses **Ctrl+P, Ctrl+Q** as the default detach sequence to exit from an attached container without stopping it. When you press Ctrl+P, Docker intercepts it as the first part of the detach sequence, waiting for Ctrl+Q to complete the sequence. If Ctrl+Q doesn't follow, the Ctrl+P keystroke is eventually discarded rather than passed to the application.

### Solution: Change Docker Detach Keys

The recommended solution is to rebind Docker's detach sequence to something less commonly used, like **Ctrl+@** (which produces the null character).

#### Option 1: Global Configuration (Recommended)
Create or edit `~/.docker/config.json`:

```json
{
  "detachKeys": "ctrl-@"
}
```

This sets the detach sequence globally for all Docker operations.

#### Option 2: Per-Container Basis
Use the `--detach-keys` flag when running or attaching to containers:

```bash
# When running a new container
docker run -it --detach-keys="ctrl-@" your-image

# When attaching to an existing container
docker attach --detach-keys="ctrl-@" container-name
```
