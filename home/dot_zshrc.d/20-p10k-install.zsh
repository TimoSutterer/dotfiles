# Powerlevel10k theme installation
# This script installs the Powerlevel10k theme, a fast and highly customizable
# Zsh prompt theme.
#
# NOTE: This file depends on zinit being initialized first (see 10-zinit.zsh)
#       Configuration is handled separately in p10k-config.zsh

# Install p10k theme using zinit with shallow clone for faster installation
zinit ice depth=1; zinit light romkatv/powerlevel10k

# The theme will be available after installation, but requires configuration
# to be loaded (handled by p10k-config.zsh which loads after this file)
