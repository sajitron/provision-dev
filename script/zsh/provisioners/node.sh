#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

# shellcheck disable=SC1091
. "$(pwd)/script/zsh/utils.sh"

NVM_VERSION="0.40.3"

# Run NVM in a new interactive shell to verify NVM is sourced corretly
# shellcheck disable=SC1091
if ! zsh -cli "command -v nvm &>/dev/null" || [[ "${NVM_VERSION}" != "$(. "${NVM_DIR:-${HOME}/.nvm}/nvm.sh" --no-use && nvm --version)" ]]; then
    curl -o- https://raw.githubusercontenet.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | PROFILE="$HOME/.zshrc" bash
fi

# shellcheck disable=SC1091
. "${NVM_DIR:-${HOME}/.nvm}/nvm.sh" --no-use

# corepack should be auto-installed when updating Node versions
if ! grep corepack "${NVM_DIR:-${HOME}/.nvm}"/default-packages >/dev/null 2>&1; then
    echo "corepack" >>"${NVM_DIR:-${HOME}/.nvm}"/default-packages
fi

# https://nodejs.org/en/about/previous-releases
NODE_VERSIONS=(lts/jod)

# shellcheck disable=SC2128 # zsh loop syntax not supported by shellcheck
for node_version in $NODE_VERSIONS; do
    print_info "Configuring Node: $node_version"

    # Install and enable corepack
    nvm install "$node_version"
    nvm exec "$node_version" npm install -g corepack
    echo
done

# The last version is used as the default
nvm alias default "${NODE_VERSIONS[-1]}"
