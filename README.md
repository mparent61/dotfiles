# Mike's Dotfiles

Idea is to use GNU `stow` command to manage symlinks in home directory.

See [this guide](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).

## Worflow

1. Add/update a subfolder, for example `./zsh` containing all ZSH dotfiles.

1. Run `stow zsh` to configure symlinks to in home directory.
