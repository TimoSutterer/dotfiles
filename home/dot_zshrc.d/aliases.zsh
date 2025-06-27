###
# Shell
###
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'

# Enable colorized output
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# List directory contents after changing directory
function cd {
  builtin cd "$@" && ls
}

###
# Git
###
alias gs='git status -sb'
alias gst='git status'
alias gc='git commit --verbose'
alias czga='czg ai -N=3'
alias gch='git checkout'
alias grs='git reset --soft HEAD~1'
alias gb='git branch'
alias gl='git log --graph --all --decorate --oneline'
# Like `gl`, but with timestamps
alias gll='\
  git log \
    --graph --all --decorate \
    --pretty=format:"%C(auto)%h %d %s %C(black)%C(bold)%ad" \
    --date=format:"%Y-%m-%d %H:%M:%S"'
# Remove `+` and `-` from diff lines, rely on color instead
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
# gbs: git-branch-status
# Fetch and show local unpushed/diverged and remote-only branches in color
gbs() {
  # update remote refs
  git fetch --prune --quiet

  local remotes branch up track branch_status colored_status
  local -a lines
  local max_branch=6 max_up=8
  local placeholder="(none)"

  # get remotes
  local remotes_array=($(git remote))

  # 1) Local branches
  while IFS=$'\t' read -r branch up track; do
    local effective_up
    if [[ -z $up ]]; then
      if [[ -n ${remotes_array[1]} ]] &&
         git show-ref --quiet "refs/remotes/${remotes_array[1]}/$branch"; then
        branch_status="no-upstream"
      else
        branch_status="unpushed"
      fi
      effective_up=$placeholder
    elif [[ -z $track ]]; then
      continue
    else
      branch_status=$track
      effective_up=$up
    fi
    lines+=("$branch|$effective_up|$branch_status")
    (( ${#branch}     > max_branch )) && max_branch=${#branch}
    (( ${#effective_up} > max_up    )) && max_up=${#effective_up}
  done < <(
    git for-each-ref refs/heads \
      --format='%(refname:short)%09%(upstream:short)%09%(upstream:track)'
  )

  # 2) Remote-only branches
  for remote in "${remotes_array[@]}"; do
    while IFS= read -r full; do
      local bn=${full#*/}
      [[ $bn == HEAD ]] && continue
      git show-ref --verify --quiet "refs/heads/$bn" && continue
      lines+=("$full|$placeholder|remote-only")
      (( ${#full}       > max_branch )) && max_branch=${#full}
      (( ${#placeholder} > max_up     )) && max_up=${#placeholder}
    done < <(
      git for-each-ref refs/remotes/$remote --format='%(refname:short)'
    )
  done

  # separators
  local dash_branch dash_up
  printf -v dash_branch '%*s' "$max_branch" '' && dash_branch=${dash_branch// /-}
  printf -v dash_up     '%*s' "$max_up"     '' && dash_up=${dash_up// /-}

  # header
  printf "%-${max_branch}s  %-${max_up}s  %s\n" "BRANCH" "UPSTREAM" "STATUS"
  printf "%s  %s  %s\n" "$dash_branch" "$dash_up" "------"

  # rows
  for entry in "${lines[@]}"; do
    IFS='|' read -r branch effective_up branch_status <<< "$entry"
    if [[ $branch_status == *ahead*   ]]; then colored_status="\e[32m$branch_status\e[0m"
    elif [[ $branch_status == *behind* ]]; then colored_status="\e[31m$branch_status\e[0m"
    elif [[ $branch_status == "remote-only" ]]; then colored_status="\e[36m$branch_status\e[0m"
    else                                        colored_status="\e[33m$branch_status\e[0m"
    fi
    printf "%-${max_branch}s  %-${max_up}s  %b\n" \
      "$branch" "$effective_up" "$colored_status"
  done
}

###
# Vim
###
alias v='nvim'

###
# Docker
###
alias d='sudo docker'
alias dc='sudo docker compose'

# List all Docker containers (running ones in green)
# Show Name, ID, Ports & Image in aligned columns
dp() {
  # Fetch all containers with Name, ID, Ports, Image and State (for coloring)
  sudo docker ps -a \
    --format \ "{{.Names}}\t{{.ID}}\t{{.Ports}}\t{{.Image}}\t{{.State}}" | \
  awk -F $'\t' '
    NR==1 {
      # Initialize header labels and set their minimum widths
      h1="NAME"; h2="ID"; h3="PORTS"; h4="IMAGE"
      w1=length(h1); w2=length(h2); w3=length(h3); w4=length(h4)
    }
    {
      # Store each column in its own array for later printing
      name[NR]=$1; id[NR]=$2; ports[NR]=$3; image[NR]=$4; state[NR]=$5
      # Update max width per column if current field is wider
      if (length($1) > w1) w1 = length($1)
      if (length($2) > w2) w2 = length($2)
      if (length($3) > w3) w3 = length($3)
      if (length($4) > w4) w4 = length($4)
    }
    END {
      # Build a dynamic printf format string with two spaces between columns
      fmt = "%-" w1 "s  %-" w2 "s  %-" w3 "s  %-" w4 "s\n"
      # Print the header row
      printf(fmt, h1, h2, h3, h4)
      # Iterate over stored rows
      for (i = 1; i <= NR; i++) {
        # If container is running, wrap the line in green ANSI codes
        if (state[i] == "running") printf("\033[32m")
        # Print the row with dynamic widths
        printf(fmt, name[i], id[i], ports[i], image[i])
        # Reset coloring after a running-container line
        if (state[i] == "running") printf("\033[0m")
      }
    }'
}
