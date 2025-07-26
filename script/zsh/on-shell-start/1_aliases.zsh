# Alias for script/bootstrap
function bootstrap {
    . script/bootstrap
}

# Alias for running the provisioner
function update-dev {
    path_to_self_dir=$(dirname $(readlink ~/.oh-my-zsh/custom/sajitron-dev-1_aliases.zsh))
    path_to_dev_env=$(
        cd "$path_to_self_dir"
        cd ../../..
        pwd
    )
    (
        cd "$path_to_dev_env"
        . script/bootstrap
    )
    . ~/.zshrc
}
