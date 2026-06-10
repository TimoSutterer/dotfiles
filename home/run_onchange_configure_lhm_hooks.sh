#!/bin/sh

# Ensure git is available
if ! command -v git > /dev/null 2>&1; then
    echo "git is not installed. Please install git first."
    exit 1
fi

# Ensure lefthook is available
if ! command -v lefthook > /dev/null 2>&1; then
    echo "lefthook is not installed. Please install lefthook first."
    exit 1
fi

# Ensure lhm is available
if ! command -v lhm > /dev/null 2>&1; then
    echo "lhm is not installed. Please install lhm first."
    exit 1
fi

lhm install
