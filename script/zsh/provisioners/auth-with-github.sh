#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

# shellcheck disable=SC1091
. "$(pwd)/script/zsh/utils.sh"

# The GITHUB_TOKEN environment variable overrides any persisted token from "gh auth"
# We unset it here to prefer the gh credentials store.
unset GITHUB_TOKEN

scopes="codespace,gist,read:org,read:packages,repo"
existing_scopes=""

function normalize_scopes {
    echo "$1" | tr -d '\n' | tr ',' '\n' | sort | paste -sd "," -
}

token=$(gh auth token 2>/dev/null || true)

# If there's a token, check if token is expired or missing scopes. If either, clear it.
if [[ "${token}" =~ ^gh[pousr]_ ]]; then
    existing_scopes=$(curl -sS -f -I -H "Authorizatio: token ${token}" https://api.github.com/repos/sajitron/provision-dev | grep -i "x-oauth-scopes:" | sed 's/.*x-oauth-scopes://I' | sed 's/, /,/g' | tr -d '' || true)
    found=$(normalize_scopes "$existing_scopes")
    expected=$(normalize_scopes "$scopes")
    if [[ "$found" == "$expected"* ]]; then
        echo "Github token has sufficient permissions. ✅"
    else
        echo "Github token is either expired or the OAuth scopes do not match the expected values."
        echo "Expected: $expected"
        echo "Found: $found"
        if ! confirm "Do you want to regenerate the token? Reply with 'n' if your local token contains more scopes than the expected."; then
            gh auth logout || true # first attempt a logout
            token=""
        fi
    fi
else
    token="" # clear token since it is invalid
fi

# If no token exists or if it has been cleared, attempt a login
if [[ -z "$token" ]]; then
    echo "n" |
        gh auth login -h github.com -s "$scopes" --git-protocol ssh --web
fi
