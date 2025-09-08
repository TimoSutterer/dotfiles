# Zsh Vi Mode Plugin
# This plugin provides enhanced vi keybindings with visual mode indicators in
# the prompt.

# Needed to make bindkey mappings/overrides (e.g. Ctrl+P) work as intended
# see https://github.com/jeffreytse/zsh-vi-mode/issues/296
ZVM_INIT_MODE=sourcing

# Install the zsh-vi-mode plugin using zinit with shallow clone for faster
# installation
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
