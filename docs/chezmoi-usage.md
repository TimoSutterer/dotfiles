# Chezmoi Usage Guide

This guide focuses on practical examples for common chezmoi operations.

## Updating Your Configuration

### Modifying Previously Entered Template Variables

To update variables you previously entered (like Git username/email):

```bash
# Re-initialize without using existing data
chezmoi init --data=false
```

This will prompt you to re-enter all template variables while keeping your existing dotfiles intact.

### Applying Changes from Your Repository

When you've made updates to your dotfiles repository:

```bash
# Update your local copy and apply changes
chezmoi update
```

This single command fetches the latest changes from your remote git repository and applies them to your home directory.

> **Note:** `chezmoi update` is equivalent to running `chezmoi pull` followed by `chezmoi apply`.

### Previewing Changes Before Applying

To see how updates would affect your system before applying them:

```bash
# Get updates from remote repository without applying them to home directory
chezmoi pull

# Review differences between chezmoi directory and home directory
chezmoi diff

# Apply selected changes from chezmoi directory to home directory
chezmoi apply --exclude=scripts

# Or apply everything from chezmoi directory to home directory
chezmoi apply
```

For a more detailed view of specific files:

```bash
# Detailed diff for specific files
chezmoi diff ~/.zshrc ~/.gitconfig
```

## Understanding Chezmoi and Git Workflow

Chezmoi adds an additional management layer between your home directory dotfiles and your Git repository:

```
Home Directory (~)  <---->  Chezmoi Directory (~/.local/share/chezmoi) = Local Git Repository <---->  Git Remote Repository
```

Refer to the [official documentation](https://www.chezmoi.io/quick-start/) for a sequence diagram with commands.

### Basic Workflow

1. **Adding files**: When you run `chezmoi add ~/.zshrc`, chezmoi copies the file from your home directory to the chezmoi directory
2. **Editing files**: `chezmoi edit ~/.zshrc` edits the copy in the chezmoi directory, not the one in your home directory
3. **Applying changes**: `chezmoi apply` copies files from the chezmoi directory to your home directory
4. **Version control**: You use git commands (or `chezmoi git -- <command>`) in the chezmoi directory to commit and push changes

This separation allows you to:

- Stage and test configuration changes before applying them
- Track the exact state of your dotfiles with version control
- Use templates and other chezmoi features that wouldn't be possible with direct git management

> **Important:** Changes made directly to files in your home directory won't be tracked until you run `chezmoi add` again.

## Troubleshooting and Maintenance

### Verifying System Status

Check if your actual dotfiles in your **home directory** match the expected state in your **chezmoi directory**:

```bash
# Show status of managed files
chezmoi status
```

### Resetting to Repository State

If your local configuration in the chezmoi directory gets corrupted:

```bash
# Reset your configuration to match the remote repository
chezmoi purge
chezmoi init TimoSutterer
```

> **Warning:** This will delete your local chezmoi directory and re-initialize it from the remote repository.
> **Note:** This process will re-run all scripts, including `run_once` scripts. See the [Re-running Scripts](#re-running-scripts) section for more details.

### Targeting Specific Files

When working with specific files:

```bash
# See source file location (in chezmoi directory)
chezmoi source-path ~/.zshrc

# See target file location (in home directory)
chezmoi target-path ~/.local/share/chezmoi/dot_zshrc
```

## Managing Files and Directories

### Adding New Files to Your Dotfiles

To start tracking a new configuration file:

```bash
# Add a specific file
chezmoi add ~/.config/nvim/init.vim

# Add a directory and its contents
chezmoi add ~/.config/alacritty
```

After adding files, they'll be stored in your local chezmoi directory (typically `~/.local/share/chezmoi`).

### Editing Tracked Files

To modify files that are already being tracked:

```bash
# Open the file in your default editor
chezmoi edit ~/.zshrc

# Specify a different editor
EDITOR=vim chezmoi edit ~/.tmux.conf
```

After editing, changes are automatically saved to your chezmoi directory, not directly to your home directory.

### Applying Specific Changes

To apply only certain modified files:

```bash
# Apply changes to specific files
chezmoi apply ~/.zshrc ~/.gitconfig
```

### Committing and Pushing Changes

After adding or editing files, you can navigate to your chezmoi directory (the local git repository at `~/.local/share/chezmoi`) with `chezmoi cd` and then use standard git commands to manage your dotfiles repository.

```bash
# Enter the chezmoi directory
chezmoi cd

# Stage, commit, and push changes to your remote git repository
git add .
git commit -m "feat: add neovim configuration"
git push

# Exit the shell in the chezmoi directory to return to where you were
exit
```

## Version Control Integration

### Working with Branches

To develop configuration changes in isolation:

```bash
# Create and switch to a feature branch in your local chezmoi git repository
chezmoi git -- checkout -b feature/new-zsh-plugins

# Make and test your changes
chezmoi add ~/.zshrc  # Copy from home directory to chezmoi directory
chezmoi apply         # Apply from chezmoi directory to home directory

# When satisfied, commit your changes to your local git repository
chezmoi git -- add .
chezmoi git -- commit -m "feat: add new zsh plugins"
```

## Migrating to a New Machine

### Quick Setup on a New System

For a new system where you need your full configuration:

```bash
# Install chezmoi and initialize from your remote git repository in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply TimoSutterer
```

> **Note:** The default `get.chezmoi.io` script downloads the chezmoi binary to `./bin` in your current directory. You may want to run this from your home directory or another appropriate location where the binary can be located, not a project directory.

### Testing in a Container First

Before applying to a new system, test in a container:

```bash
docker run -it --rm ubuntu
apt update && apt install -y curl git sudo
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply TimoSutterer
```

## Script Management

### Re-running Scripts

Scripts in chezmoi are typically categorized as:

- `run_once_` - Run exactly once on each machine
- `run_onchange_` - Run when script content changes
- `run_` - Run every time you apply your dotfiles

> **Important:** When updating `run_once` scripts in your repository, machines that previously ran them won't automatically re-run them when you update.

To re-run a `run_once` script:

```bash
# Force re-run by removing its record
chezmoi state delete-bucket --bucket=scriptState
```

For specific scripts:

```bash
# Re-run a specific script by removing its individual entry
chezmoi state delete --bucket=scriptState run_once_install_global_npm_packages.sh
```

Then apply your dotfiles again:

```bash
chezmoi apply
```

Alternative approach: If you need to re-run all scripts, you can also use the purge and re-init method:

```bash
# This will remove all chezmoi state, including script execution history
chezmoi purge
chezmoi init TimoSutterer
chezmoi apply
```

This is more extreme but useful when you want to start with a clean slate, as it removes all chezmoi state and reinitializes from your repository.

### Checking Script Execution Status

To see which scripts have been run:

```bash
# View the script state
chezmoi state data --bucket=scriptState
```

## Advanced Configuration

### Creating Machine-Specific Configurations

#### Using Templates

For machine-specific settings, use templates with conditional logic:

```bash
# Edit a template file
chezmoi edit --template ~/.gitconfig
```

Example template content:

```
[user]
    name = {{ .gitUserName }}
    email = {{ .gitUserEmail }}

[core]
    editor = {{ if eq .chezmoi.hostname "work-laptop" }}vim{{ else }}nano{{ end }}
```

#### Using `.chezmoiexternal` for External Files

For machine-specific external dependencies:

```yaml
# .chezmoiexternal.toml
{{ if eq .chezmoi.os "darwin" }}
[".hammerspoon/Spoons/SpoonInstall.spoon"]
    type = "archive"
    url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"
    stripComponents = 1
{{ end }}
```

#### Using `.chezmoiignore`

To exclude certain files on specific machines:

```
# .chezmoiignore
{{ if ne .chezmoi.os "darwin" }}
Library/
.hammerspoon/
{{ end }}
```

### Managing Encrypted Secrets

To securely store sensitive information:

```bash
# Encrypt a file using gpg
chezmoi add --encrypt ~/.ssh/id_rsa

# Edit an encrypted file
chezmoi edit --decrypt ~/.ssh/id_rsa
```

## Task Automation

### Creating Custom Script Commands

For frequently used operations:

```bash
# Add to your .zshrc or similar
function dotfiles-update() {
  chezmoi update
  source ~/.zshrc
}

function dotfiles-edit() {
  chezmoi edit "$1"
  chezmoi apply "$1"
}
```

### Scheduled Updates

To keep your dotfiles in sync with the repository:

```bash
# Add to crontab
0 9 * * * chezmoi update
```

Or create a scheduled task/service on your system.
