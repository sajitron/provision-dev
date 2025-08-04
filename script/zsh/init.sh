#!/bin/zsh
# shellcheck shell=bash

set -e -o pipefail

if [[ "$SHELL" =~ /\/zsh/ ]]; then
    echo -e "\033[0;31m[Prerequisite] zsh is required.\033[0m"
    exit 10
fi

# source utilities (colours, logging etc)
# shellcheck disable=SC1091
. ./script/zsh/utils.sh

function on_error {
    # shellcheck disable=SC2317
    if [[ $? -gt 0 ]]; then
        print_error "Provisioning failed. Try again or raise an issue on GitHub."
    fi
}

trap on_error EXIT

echo
print_info "🏭 Development Environment Provisioner"
echo
print_info "Starting the development machine provisioning process."
print_info "You can run this script at any time to keep your machine up to date."

# some latter-run scripts use corepack indirectly. Disable the download prompt
# since we often redirect stdio to /dev/null and prompts don't work anyway.
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

run_provisioner "oh-my-zsh" ./script/zsh/provisioners/omz.sh
run_provisioner "homebrew" ./script/zsh/provisioners/brew.sh
run_provisioner "git" ./script/zsh/provisioners/git.sh
run_provisioner "node" ./script/zsh/provisioners/node.sh
run_provisioner "optional" ./script/zsh/provisioners/optional.sh

print_success "Dev tooling initialization complete"
