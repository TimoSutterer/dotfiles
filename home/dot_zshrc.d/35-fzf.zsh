# fzf shell integration
# This file enables fzf's Zsh keybindings and completion support, including
# Ctrl-R for history search, Ctrl-T for file search, and Alt-C for directory
# navigation.
if command -v fzf >/dev/null 2>&1; then
  if command -v fdfind >/dev/null 2>&1; then
    # Use fd for Git-aware filtering while preserving hidden entries and
    # symlinks.
    export FZF_CTRL_T_COMMAND='fdfind --hidden --follow --exclude .git'
    export FZF_ALT_C_COMMAND='fdfind --hidden --follow --exclude .git --type d'
  fi

  source <(fzf --zsh)
fi
