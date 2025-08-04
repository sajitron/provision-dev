#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

# shellcheck disable=SC1091
. "$(pwd)/script/zsh/utils.sh"

# If "oh-my-zsh" is installed, trigger an update, otherwise install.
if [[ "$(basename "$ZSH")" == ".oh-my-zsh" ]]; then
    "$ZSH/tools/upgrade.sh"
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ -z "$ZSH_CUSTOM" ]]; then
    export ZSH_CUSTOM=$ZSH/custom
fi

namespace=sajitron-dev

# symlink custom zsh scripts to source on shell startup
for file in "$(pwd)"/script/zsh/on-shell-start/*(.); do
    ln -s -f "$file" "$ZSH_CUSTOM/$namespace-$(basename "$file")"
done

# cleanup old symlinks
for file in "$ZSH_CUSTOM"/"$namespace"-*; do
    base=$(basename "$file")
    local_file="${base//"$namespace"-/}"
    if [[ ! -f "$(pwd)"/script/zsh/on-shell-start/"${local_file}" ]]; then
        if confirm "$file may be from an outdated version of provision-dev. Would you like to delete it?"; then
            rm -f "$file"
        else
            echo "Keeping the file."
        fi
    fi
done
