#!/bin/sh

# Check if Commitlint should be skipped
if [ "$SKIP_COMMITLINT" = "1" ]; then
    echo "Skipping commitlint as SKIP_COMMITLINT is set."
    exit 0
fi

# Run Commitlint and show its output before prompting for an override
commitlint_output="$(mktemp)"
trap 'rm -f "$commitlint_output"' EXIT

if npx commitlint --edit "$1" > "$commitlint_output" 2>&1; then
    exit 0
fi

if [ -s "$commitlint_output" ]; then
    cat "$commitlint_output" >&2
fi

{
    echo "Commit message does not comply with the standards."

    # Assigns stdin to keyboard to be able to read user input
    exec < /dev/tty

    # Ask the user if they want to proceed with the commit despite the message
    # not complying
    while true; do
        read -r -p "Do you want to commit anyway? (Y/n): " choice
        choice="${choice:-Y}"  # Default to 'Y' if no input is provided

        case "$choice" in
            Y|y )
                echo "Proceeding with commit."

                # Provide instructions on how to update or undo the commit
                echo
                echo -n "If you want to update your commit message to comply "
                echo "with the standards, you can run:"
                echo "  git commit --amend --verbose"
                echo "To undo the commit, you can run:"
                echo "  git reset --soft HEAD~1"
                echo

                exit 0
                ;;
            N|n )
                echo "Aborting commit."
                exit 1
                ;;
            * )
                echo "Invalid option. Please enter 'y' or 'n'."
                ;;
        esac
    done
}
