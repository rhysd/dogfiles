#!/bin/sh

dotfiles="$HOME/.vimrc $HOME/.vimshrc $HOME/.gvimrc $HOME/.bashrc $HOME/.zshrc $HOME/.emacs.d/init.el $HOME/.gemrc $HOME/.vim/snippets"

for dotfile in $dotfiles
do
    dotfile_name=${dotfile##*/}
    case "$dotfile_name" in
    .* )
        dotfile_name=${dotfile##*.}
        ;;
    esac
    cp -r $dotfile $dotfile_name
done
git add *
git commit -m "updated at `date`"
git push origin master
