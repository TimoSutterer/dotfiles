#!/bin/sh

# NOTE: Update instructions below are commented out to prevent unwanted automatic updates
# that might introduce breaking changes. Update plugins manually when needed.

# Ensure tmux is available
if ! command -v tmux > /dev/null 2>&1; then
    echo "tmux is not installed. Please install tmux first."
    exit 1
fi

# Ensure git is available
if ! command -v git > /dev/null 2>&1; then
    echo "git is not installed. Please install git first."
    exit 1
fi

# Resolve XDG paths safely
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TMUX_CONFIG_DIR="$XDG_CONFIG_HOME/tmux"
TMUX_CONF="$TMUX_CONFIG_DIR/tmux.conf"
TPM_DIR="$TMUX_CONFIG_DIR/plugins/tpm"

# Install Tmux Plugin Manager
if [ ! -d "$TPM_DIR" ]; then
  echo "Tmux Plugin Manager is not installed. Cloning..."
  mkdir -p "$TMUX_CONFIG_DIR/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "Tmux Plugin Manager is installed."
#else
#  echo "Tmux Plugin Manager is installed. Checking for updates..."
#  cd "$TPM_DIR" || exit
#  # Determine the current branch
#  branch=$(git rev-parse --abbrev-ref HEAD)
#  # Fetch the latest changes for the current branch
#  git fetch origin "$branch"
#  LOCAL=$(git rev-parse HEAD)
#  REMOTE=$(git rev-parse origin/"$branch")
#  if [ "$LOCAL" != "$REMOTE" ]; then
#    echo "New version detected. Updating Tmux Plugin Manager..."
#    git pull
#  fi
#  echo "Tmux Plugin Manager is up to date."
fi

# Install plugins
echo "Installing Tmux Plugin Manager plugins..."

if tmux has-session 2>/dev/null; then
  # When tmux is already running, use TPM's interactive binding script.
  # This installs missing plugins and refreshes the running tmux environment.
  "$TPM_DIR/bindings/install_plugins"
else
  # When tmux is not running, use TPM's command-line installer.
  # Plugins will be sourced normally when tmux starts and reads tmux.conf.
  "$TPM_DIR/bin/install_plugins"
fi

echo "Tmux Plugin Manager plugins installed."

# Source tmux.conf in the running server as an extra safety net.
# This matters for plugins like vim-tmux-navigator because their tmux-side
# bindings must be registered in the active tmux server.
if tmux has-session 2>/dev/null; then
  if [ -f "$TMUX_CONF" ]; then
    tmux source-file "$TMUX_CONF"
    echo "Reloaded tmux configuration from $TMUX_CONF."
  elif [ -f "$HOME/.tmux.conf" ]; then
    tmux source-file "$HOME/.tmux.conf"
    echo "Reloaded tmux configuration from $HOME/.tmux.conf."
  fi
fi

## Update plugins
#echo "Updating Tmux Plugin Manager plugins..."
#if tmux has-session 2>/dev/null; then
#  "$TPM_DIR/bindings/update_plugins" all
#else
#  "$TPM_DIR/bin/update_plugins" all
#fi
#echo "Tmux Plugin Manager plugins updated."

echo "Tmux Plugin Manager setup complete."
