#!/usr/bin/env bash

# Default installation path
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DEFAULT_UVENV_ROOT="${XDG_DATA_HOME}/uvenv"

# Use custom path if UVENV_ROOT is set
INSTALL_PATH="${UVENV_ROOT:-$DEFAULT_UVENV_ROOT}"

# Create directories
mkdir -p "${INSTALL_PATH}"

# Install scripts
cp uv-python-version "${INSTALL_PATH}/"
cp uv-python-shims "${INSTALL_PATH}/"
cp shell_import.sh "${INSTALL_PATH}/"
cp uvenv-functions.sh "${INSTALL_PATH}/"

# Make scripts executable
chmod +x "${INSTALL_PATH}"/*

# Add to shell config if not already present
SHELL_IMPORT="source ${INSTALL_PATH}/shell_import.sh"
if ! grep -q "source.*uvenv/shell_import.sh" "$HOME/.zshrc"; then
    echo -e "\n# UV Python Version Management\n${SHELL_IMPORT}" >> "$HOME/.zshrc"
fi

echo "Installed uvenv to ${INSTALL_PATH}"