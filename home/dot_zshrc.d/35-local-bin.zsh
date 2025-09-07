# Local bin directory PATH setup
# This script adds ~/.local/bin to the PATH environment variable to support
# user-installed tools like chezmoi and other local binaries.
#
# ~/.local/bin is the standard location for user-specific executable files
# that don't require system-wide installation. Many tools installed via
# package managers or manual installation use this directory.
#
# By adding this to PATH, we ensure that user-installed binaries are
# accessible from anywhere in the shell without specifying full paths.
export PATH="$HOME/.local/bin:$PATH"
