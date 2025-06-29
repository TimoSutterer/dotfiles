#!/bin/sh

# NOTE: Update instructions below are commented out to prevent unwanted automatic updates
# that might introduce breaking changes. Update plugins manually when needed.

# Ensure tmux is available
if ! command -v tmux > /dev/null 2>&1; then
    echo "tmux is not installed. Please install tmux first."
    exit 1
fi

# Install Tmux Plugin Manager
TPM_DIR="$XDG_CONFIG_HOME/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Tmux Plugin Manager is not installed. Cloning..."
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
tmux new-session -d -s tmp_install_tpm_plugins && \
  tmux run-shell '$TPM_DIR/bin/install_plugins' && \
  tmux kill-session -t tmp_install_tpm_plugins
echo "Tmux Plugin Manager plugins installed."
## Update plugins
#echo "Updating Tmux Plugin Manager plugins..."
#tmux new-session -d -s tmp_update_tpm_plugins && \
#  tmux run-shell '$TPM_DIR/bin/update_plugins all' && \
#  tmux kill-session -t tmp_update_tpm_plugins
#echo "Tmux Plugin Manager plugins updated."
echo "Note: You may need to restart tmux or reload its configuration with" \
     "'tmux source ~/.tmux.conf' for the changes to take effect."
