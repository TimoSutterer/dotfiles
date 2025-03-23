# Set up shell environment for pyenv
# https://github.com/pyenv/pyenv/blob/master/README.md#b-set-up-your-shell-environment-for-pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
# Enable pyenv-virtualenv auto-activation for virtualenvs
# https://github.com/pyenv/pyenv-virtualenv/blob/master/README.md#installation
eval "$(pyenv virtualenv-init -)"
