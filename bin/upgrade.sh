# Upgrade all my tools

brew update
brew doctor

brew install \
    autoenv \
    autossh \
    coreutils \
    git \
    htop-osx \
    rename \
    tmux \
    trash \
    the_silver_searcher \
    zsh \
    homebrew/versions/ansible19

# Ranger + plugins (esp syntax highlighting)
brew install ranger atool w3m mediainfo

brew upgrade --all

# Python
brew install python
brew install python3
brew unlink python && brew link --overwrite python
brew unlink python3 && brew link --overwrite python3
brew linkapps python
brew linkapps python 3

# VIM
brew install vim --override-system-vi --with-python3

# Custom neovim tap
brew tap neovim/neovim
brew reinstall --HEAD neovim

# Oh-My-Zsh
env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
