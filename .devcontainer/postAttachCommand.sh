#!/bin/bash
# .devcontainer/postAttachCommand.sh
echo "🏗️ Post attach command"
# Check if the script is running on GitHub Codespaces
if [[ -n "${CODESPACES}" || -n "${GITHUB_CODESPACE_TOKEN}" ]]; then
    printf "Running in GitHub Codespaces.\nNo need to run any commands."
    exit 0
else
    echo "Running on local host"
fi
