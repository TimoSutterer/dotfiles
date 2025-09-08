# Zsh history configuration
# This file configures history behavior

# Keybindings for history navigation
# history-beginning-search-* searches through history for commands that begin
# with the text up to the cursor position. This allows you to type the beginning
# of a command and then press Ctrl+P/Ctrl+N to find matching commands in history.
# Ctrl+P to search backward in history
bindkey '^p' history-beginning-search-backward
# Ctrl+N to search forward in history
bindkey '^n' history-beginning-search-forward

# Set history file location
HISTFILE="$HOME/.zsh_history"

# Configure history size
HISTSIZE=10000               # Number of commands to keep in memory
SAVEHIST=$HISTSIZE           # Number of commands to save to disk

# Commands to exclude from being written to the history file (still visible in-session)
HISTORY_IGNORE='(ls|ls -l|ls -la|l|ll|la|cd|cd ..|..|pwd|exit|clear|history)'

# History file options
setopt appendhistory         # Append to history file rather than overwrite
setopt sharehistory          # Share history between all sessions
setopt inc_append_history    # Add commands as they are typed, not at shell exit
setopt hist_ignore_all_dups  # Delete old entry if new entry is a duplicate
setopt hist_find_no_dups     # Don't display duplicates when searching
setopt hist_ignore_space     # Don't record commands that start with a space
setopt hist_reduce_blanks    # Remove superfluous spaces from commands
