#!/bin/zsh
# shellcheck shell=bash

COLOUR_MAGENTA='\033[0;95m'
COLOUR_RED='\033[0;31m'
COLOUR_GREEN='\033[0;32m'
COLOUR_YELLOW='\033[0;33m'
NO_COLOUR='\033[0m'

function print_warning {
    echo -e "${COLOUR_YELLOW}${1}${NO_COLOUR}"
}

function print_error {
    echo -e "${COLOUR_RED}${1}${NO_COLOUR}"
}

function print_success {
    echo -e "${COLOUR_GREEN}${1}${NO_COLOUR}"
}

function print_info {
    echo -e "${COLOUR_MAGENTA}${1}${NO_COLOUR}"
}

function confirm {
    local msg="$1"

    echo "$msg (Y/N): "
    while true; do
        read -r "yn"

        # shellcheck disable=SC2154
        if [[ "$yn" =~ [Yy]+ ]]; then return 0; fi
        if [[ "$yn" =~ [Nn]+ ]]; then return 1; fi

        echo "Expected Y/n"
    done
}

function run_provisioner {
    local name="$1"
    local script_path="$2"

    if [[ -n "$SKIP_PROVISIONER" ]] && [[ "$SKIP_PROVISIONER" =~ (^|,)"$name" ]]; then
        print_info "⏭️ Skipping $name..."
        return
    fi

    print_info "🔄 Provisioning $name... \n"

    if ! zsh "$script_path" 2>&1 | sed 's/^/  /'; then
        print_error "❌ Failed to provision $name."
        exit 2
    fi
    print_info "✅ Provisioned $name\n"

    # Reload zsh to ensure the provisioner run takes effect in the current shell
    # shellcheck disable=SC2088
    if [ -f "$HOME/.zshrc" ]; then
        if ! {
            # shellcheck disable=SC1090
            . ~/.zshrc
        }; then
            echo "Failed to source .zshrc" >&2
            return 1
        fi
    fi
}
