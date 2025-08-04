#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

# shellcheck disable=SC1091
. "$(pwd)/script/zsh/utils.sh"

# Ensures "~/.local/bin" is in the PATH since some tools are installed there
if ! zsh -cli "echo $PATH | grep -q '~/.local/bin'"; then
    # shellcheck disable=SC2016
    echo 'export PATH="$HOME/.local/bin/:$PATH"' >>"$HOME/.zshrc"
fi

# shellcheck disable=SC1091
. "$HOME/.zshrc"

if ! zsh -cli "command -v claude &>/dev/null"; then
    if confirm "Would you like to install Claude (AI Agent)?"; then
        print_info "Installing Claude..."
        curl -fsSL claude.ai/install.sh | bash
    fi
fi
