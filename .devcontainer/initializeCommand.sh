#!/bin/bash
# .devcontainer/initializeCommand.sh

function github_cli_check() {

    if ! command -v gh &> /dev/null
    then
        echo "⚠️ github-cli could not be found"
        return 1
    else
        echo "✅ github-cli is installed"
        gh --version
    fi

    echo "Check if gh is logged in"
    if ! gh auth status | grep -q "Logged in to github.com"
    then
        echo "⚠️ github-cli is not logged in"
        return 1
    else
        echo "✅ github-cli is logged in"
        gh auth status
    fi

    echo "Write environment variables to .devcontainer/.env file"
    echo "GITHUB_TOKEN=$(gh config get oauth_token --host github.com)" > .devcontainer/.env
    echo "GITHUB_USER=$(gh api user | jq -r '.login')" >> .devcontainer/.env

}

function segger_check() {

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: 'jq' is not installed. Please install 'jq' to parse devcontainer.json."
  exit 1
fi

# Extract INSTALL_JLINK and JLINK_PACKAGE_FILE from JSON
DEVCONTAINER_JSON=".devcontainer/devcontainer.json"
INSTALL_JLINK=$(jq -r '.build.args.INSTALL_JLINK // "false"' "$DEVCONTAINER_JSON")
JLINK_PACKAGE_FILE=$(jq -r '.build.args.JLINK_PACKAGE_FILE // "dummy.deb"' "$DEVCONTAINER_JSON")

if [ "$INSTALL_JLINK" = "true" ]; then
    echo "INSTALL_JLINK is true"
elif [ "$INSTALL_JLINK" = "false" ]; then
    echo "INSTALL_JLINK is false"
else
    echo "Error: INSTALL_JLINK has invalid value '$INSTALL_JLINK'. Expected 'true' or 'false'."
    exit 1
fi

if [ "$INSTALL_JLINK" == "true" ] && [ ! -f ".devcontainer/$JLINK_PACKAGE_FILE" ]; then
    # If install is true and the file does not exist exit
    echo "🛑 The Segger driver file does not exist: .devcontainer/$JLINK_PACKAGE_FILE"
    exit 1
elif [ "$INSTALL_JLINK" == "false" ] && [ ! -f ".devcontainer/$JLINK_PACKAGE_FILE" ]; then
    # If install is false and file does not exist create a dummy one so `COPY` does not fail
    echo "Creating a dummy file"
    touch ".devcontainer/$JLINK_PACKAGE_FILE"
else
    echo "Package file already exists."
fi

}

echo "🏗️ Initialize command"

# Check if the script is running on GitHub Codespaces
if [[ -n "${CODESPACES}" || -n "${GITHUB_CODESPACE_TOKEN}" ]]; then
    printf "Running in GitHub Codespaces.\nNo need to export any keys."
    segger_check
    exit 0
# Check if the script is running on GitHub Actions
elif [[ "${GITHUB_ACTIONS}" == "true" ]]; then
    echo "Running in GitHub Actions."
    echo "No need to export any keys."
    segger_check
    exit 0
else
    echo "Running on local host"
    github_cli_check
    segger_check

    if [ -z "$SSH_AUTH_SOCK" ]; then
        echo "SSH_AUTH_SOCK is not set"
        echo "⚠️ SSH authentication to github.com will not work"
        echo "https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys"
    fi
fi
