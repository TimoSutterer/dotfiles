# Powerlevel10k theme installation and configuration
# This script installs the Powerlevel10k theme, a fast and highly customizable
# Zsh prompt theme.
#
# NOTE: This file depends on zinit being initialized first (see 00-zinit.zsh)

# Install p10k theme using zinit with shallow clone for faster installation
zinit ice depth=1; zinit light romkatv/powerlevel10k