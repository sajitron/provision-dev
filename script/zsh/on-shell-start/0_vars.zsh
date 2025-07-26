# Add Homebrew to path
if command -v /opt/homebrew/bin/brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#todo set up HTTPS support

# Add pyenv to path
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
fi

# set github token to environment variable
if [[ -z "GITHUB_TOKEN" ]]; then
    export GITHUB_TOKEN=$(gh auth token 2>/dev/null)
fi
