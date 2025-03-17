# Pyenv Usage Guide

This guide focuses on practical examples for common pyenv and pyenv-virtualenv operations.

## Essential Commands

### [New Project Setup](#starting-a-new-project)

```bash
mkdir my-project && cd my-project
pyenv install 3.13.2
pyenv virtualenv 3.13.2 my-project-3.13.2
pyenv local my-project-3.13.2
pip install -r requirements.txt
```

### [Version Management](#basic-version-management)

```bash
# Install a Python version
pyenv install 3.13

# List installed versions
pyenv versions

# Set global Python version
pyenv global 3.13

# Set local (project) Python version for current directory
pyenv local 3.13
```

### [Virtual Environments](#using-pyenv-virtualenv)

```bash
# Create virtual environment
pyenv virtualenv 3.13 my-project-3.13

# Set local Python to virtual environment (also enables auto-activation)
pyenv local my-project-3.13

# List virtual environments
pyenv virtualenvs

# Delete a virtual environment
pyenv uninstall my-project-3.13
```

For more details, see the corresponding sections: [Workflow Patterns](#workflow-patterns), [Basic Version Management](#basic-version-management), and [Using Pyenv-Virtualenv](#using-pyenv-virtualenv).

## Understanding Pyenv

Pyenv allows you to:

1. Change the global Python version
2. Install multiple Python versions
3. Set project-specific Python versions
4. Create and manage virtual environments
5. Switch between versions seamlessly

## Basic Version Management

### Listing Available Versions

To see which Python versions you can install:

```bash
# List all available Python versions
pyenv install --list

# Filter for specific versions
pyenv install --list | grep "3.11"
```

### Installing Python Versions

```bash
# Install a specific Python version
pyenv install 3.11.4

# Install the latest Python 3.10
pyenv install 3.10

# Install with verbose output for troubleshooting
pyenv install -v 3.12.0
```

> **Note:** Installation issues often stem from missing build dependencies. See [Troubleshooting](#troubleshooting) for common solutions.

### Viewing Installed Versions

```bash
# List all installed Python versions
pyenv versions

# Show current active Python version
pyenv version
```

### Setting Python Versions

Pyenv uses a hierarchy of version settings:

1. **Shell-specific** - Sets Python version for the current shell session only
2. **Local** - Sets Python version for the current directory (creates `.python-version` file)
3. **Global** - Sets Python version system-wide (for the current user)

```bash
# Set Python version for current shell session only
pyenv shell 3.11.4

# Set Python version for current directory (project-specific)
pyenv local 3.11.4

# Set Python version globally (user-wide default)
pyenv global 3.11.4

# Use multiple versions with priority order (left to right)
pyenv global 3.11.4 3.10.12 system
```

The last example creates a "fallback" system where commands look for 3.11.4 first, then 3.10.12, and finally the system Python.

### Removing Python Versions

```bash
# Remove a specific Python version
pyenv uninstall 3.11.4
```

## Using Pyenv-Virtualenv

### Creating Virtual Environments

```bash
# Create a virtualenv using a specific Python version
pyenv virtualenv 3.11.4 my-project-3.11.4

# Create a virtualenv from the current Python version
pyenv virtualenv my-project
```

> **Note:** Virtual environments are stored in `$(pyenv root)/versions/` alongside your Python versions.

### Activating/Deactivating Environments

```bash
# Manually activate a virtualenv
pyenv activate my-project-3.11.4

# Manually deactivate current virtualenv
pyenv deactivate
```

### Automatic Environment Activation

One of pyenv-virtualenv's most useful features is auto-activation:

```bash
# Set a specific virtual environment for the current directory
# This creates a .python-version file in the directory
pyenv local my-project-3.11.4
```

Now, whenever you enter this directory, the environment will automatically activate, and when you leave, it will deactivate.

### Managing Virtual Environments

```bash
# List all virtual environments
pyenv virtualenvs

# Delete a virtual environment
pyenv uninstall my-project-3.11.4
```

## Workflow Patterns

### Starting a New Project

```bash
# Create project directory
mkdir my-new-project && cd my-new-project

# Install specific Python version if needed
pyenv install 3.11.4

# Create a virtual environment for the project
pyenv virtualenv 3.11.4 my-new-project-3.11.4

# Set the local Python to the new environment
pyenv local my-new-project-3.11.4

# Verify the environment is active
python --version
pip --version

# Install project dependencies
pip install -r requirements.txt  # or specific packages
```

### Working with Poetry or Other Tools

When using Python package managers like Poetry:

```bash
# Create and set Python environment
pyenv install 3.11.4
pyenv virtualenv 3.11.4 project-3.11.4
pyenv local project-3.11.4

# Initialize poetry with the correct Python
poetry init

# Install dependencies
poetry add requests pandas
```

### Multiple Python Versions for Testing

Testing a package against multiple Python versions:

```bash
# Create test environments
pyenv install 3.9.18 3.10.12 3.11.4
pyenv virtualenv 3.9.18 test-3.9
pyenv virtualenv 3.10.12 test-3.10
pyenv virtualenv 3.11.4 test-3.11

# Run tests in each environment
pyenv shell test-3.9
pytest

pyenv shell test-3.10
pytest

pyenv shell test-3.11
pytest
```

> **Tip:** You can automate this with a bash script or use tox with pyenv.

## Maintenance and Updates

### Updating Pyenv

```bash
# Update pyenv itself
cd $(pyenv root)
git pull

# Update pyenv-virtualenv plugin
cd $(pyenv root)/plugins/pyenv-virtualenv
git pull
```

### Upgrading Python in Existing Environments

```bash
# Install new Python version
pyenv install 3.12.0

# Create new environment with the same packages
pyenv virtualenv 3.12.0 project-3.12.0
pyenv activate project-3.12.0
pip install -r <(pyenv activate old-env && pip freeze)

# Switch the local version
pyenv local project-3.12.0

# Optionally remove old environment
pyenv uninstall project-3.11.4
```

## Project Configuration

### Creating a Project Template

Save time by creating a project initialization script:

```bash
#!/bin/bash
# create_python_project.sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <project_name> [python_version]"
    exit 1
fi

PROJECT_NAME=$1
PYTHON_VERSION=${2:-3.11.4}  # Default to Python 3.11.4 if not specified

mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Install Python version if not already installed
pyenv install -s "$PYTHON_VERSION"

# Create and activate virtualenv
VENV_NAME="${PROJECT_NAME}-env"
pyenv virtualenv "$PYTHON_VERSION" "$VENV_NAME"
pyenv local "$VENV_NAME"

# Create initial project structure
mkdir -p src tests docs

# Create basic files
touch README.md
touch src/__init__.py
touch tests/__init__.py

# Create a basic requirements file
cat > requirements-dev.txt << EOF
pytest==7.4.0
black==24.1.1
isort==5.13.2
flake8==6.1.0
mypy==1.5.1
EOF

# Install development dependencies
pip install -r requirements-dev.txt

echo "Project $PROJECT_NAME initialized with Python $PYTHON_VERSION"
echo "Virtual environment $VENV_NAME created and activated"
```

Make the script executable and place it in your PATH:

```bash
chmod +x create_python_project.sh
mv create_python_project.sh ~/.local/bin/
```

### Setting Default Python Version per Project Type

For consistent environments across similar projects:

```bash
# Create a base Django environment
pyenv install 3.11.4
pyenv virtualenv 3.11.4 django-base

# Install Django packages
pyenv activate django-base
pip install django djangorestframework django-debug-toolbar

# When starting a new Django project, clone the base
pyenv virtualenv django-base new-django-project
pyenv local new-django-project
```
