#!/bin/sh

###
# Ensure npm is available
###
if ! command -v npm > /dev/null 2>&1; then
    echo "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

###
# Install global npm packages
###

# Commit message linting
# Make sure to keep in sync with the versions in package.json and
# package-lock.json to avoid conflicts with GitHub Actions workflows.
npm install -g @commitlint/cli@19.6.1 @commitlint/config-conventional@19.6.0

# Interactive Commitizen CLI 
npm install -g czg@1.11.1

echo "Global npm packages installed."
