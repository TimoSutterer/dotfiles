# zoxide shell integration
# zoxide remembers the directories you visit and ranks them by frecency.
# `z <dir>` jumps to the best match and `zi` picks one with fzf. sesh lists
# these directories in its tmux session picker.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
