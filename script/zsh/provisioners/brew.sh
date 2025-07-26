#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

export HOMEBREW_COLOR=1
export HOMEBREW_BREWFILE_VERBOSE=info

if ! command -v brew &>/dev/null; then
    if [[ ! -f /opt/homebrew/bin/brew ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# update brew remotes
brew update

# install from Brewfile
brew bundle install --file=./script/zsh/provisioners/data/Brewfile.core

# todo install optional brewfile dependencies

# Yarn is managed by corepack. remove global version
brew uninstall -f yarn

# update all installed packages
brew upgrade
