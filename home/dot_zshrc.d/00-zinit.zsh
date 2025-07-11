# Zinit plugin manager setup for Zsh
# This script automatically installs and initializes zinit, a fast and flexible
# Zsh plugin manager that allows for easy installation and management of Zsh
# plugins, themes, and other enhancements.
# 
# IMPORTANT: This file must be sourced before any other files that use zinit
# commands (like p10k.zsh), as zinit needs to be initialized first.

# Set the zinit installation directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Create the parent directory if it doesn't exist
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"

# Clone zinit repository if it's not already installed
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source the zinit script to initialize the plugin manager
source "${ZINIT_HOME}/zinit.zsh"