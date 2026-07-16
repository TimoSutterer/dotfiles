# fzf shell integration
# This file enables fzf's Zsh keybindings and completion support, including
# Ctrl-R for history search, Ctrl-T for file search, and Alt-C for directory
# navigation.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
