# Zsh autosuggestions plugin configuration
# This plugin provides fish-like autosuggestions for Zsh based on command
# history. It suggests commands as you type based on your shell history, making
# command entry faster.
#
# Features:
# - Real-time suggestions appear in gray text as you type
# - Suggestions are based on your command history
# - Accept suggestions with configured key bindings
# - Customizable highlighting and behavior

# Install the zsh-autosuggestions plugin using zinit
zinit light zsh-users/zsh-autosuggestions

# Bind Ctrl+f to accept the current autosuggestion
# This allows quick acceptance of the suggested command without using arrow keys
bindkey '^f' autosuggest-accept