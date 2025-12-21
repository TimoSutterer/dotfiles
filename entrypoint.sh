#!/bin/sh
set -e

# Source the custom container startup script if it exists
STARTUP_SCRIPT="$HOME/.local/bin/container-startup.sh"
if [ -f "$STARTUP_SCRIPT" ]; then
    . "$STARTUP_SCRIPT"
fi

# Execute the main command passed to the container. This command comes from:
# - The CMD instruction in the Dockerfile
# - Arguments passed to `docker run` (overriding CMD)
exec "$@"
