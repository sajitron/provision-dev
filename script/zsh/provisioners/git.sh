#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

# shellcheck disable=SC1091
. "$(pwd)/script/zsh/utils.sh"

git config --global init.defaultBranch main
git config --global log.date iso-local
git config --global core.ignorecase false

# Rewrite HTTP urls to SSH (more secure)
if [[ "https://github.com/" != "$(git config --global --get url."git@github.com:".insteadOf || true)" ]]; then
    git config --global --replace-all url."git@github.com:".insteadOf "https://github.com/"
fi
if [[ "https://github.com/" != "$(git config --global --get url."ssh://git@github.com/".insteadOf "https://github.com/" || true)" ]]; then
    git config --global --replace-all url."ssh://git@github.com/".insteadOf "https://github.com/"
fi

# get git email and name

while [[ -z "$(git config --global --get user.email || true)" ]]; do
    echo "Please enter your github email: "
    read -r "email"

    git config --global user.email "$email"
done

while [[ -z "$(git config --global --get user.name || true)" ]]; do
    echo "Please enter your name. This will be used to author git commits: "
    read -r "fullname"

    git config --global user.name "$fullname"
done

echo "Your git email is $(git config --global --get user.email)"
echo "Your git username is $(git config --global --get user.name)"

# Login to Github and persist auth token
# ./script/zsh/provisioners/auth-with-github.sh
