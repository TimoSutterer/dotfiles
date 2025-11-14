#!/bin/sh
set -eu

# Set completion directory using XDG standard or fallback to ~/.cache
ZSH_COMPLETION_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
# Create completion directory if it doesn't exist
mkdir -p "$ZSH_COMPLETION_DIR"

# Generate uv completion if uv is available
if command -v uv > /dev/null 2>&1; then
  uv generate-shell-completion zsh > "$ZSH_COMPLETION_DIR/_uv"
fi

# Generate uvx completion if uvx is available
if command -v uvx > /dev/null 2>&1; then
  uvx --generate-shell-completion zsh > "$ZSH_COMPLETION_DIR/_uvx"
fi
