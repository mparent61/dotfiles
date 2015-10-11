# Upgrade all my tools

brew update
brew doctor

brew install \
    autoenv \
    coreutils \
    git \
    htop-osx \
    python3 \
    tmux \
    trash \
    the_silver_searcher \
    zsh

brew upgrade --all

# Custom neovim tap
brew tap neovim/neovim
brew reinstall --HEAD neovim

# Oh-My-Zsh
env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
