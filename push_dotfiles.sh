#!/bin/sh

dotfiles="$HOME/.pvimrc $HOME/.vimrc $HOME/.vimshrc $HOME/.gvimrc $HOME/.bashrc $HOME/.zshrc $HOME/.emacs.d/init.el $HOME/.gemrc"
directories=""

for dotfile in $dotfiles
do
    dotfile_name=${dotfile##*/}
    case "$dotfile_name" in
    .* )
        dotfile_name=${dotfile##*.}
        ;;
    esac
    cp $dotfile $dotfile_name
done

for directory in $directories
do
    cp -r $directory .
done

git add -A
git commit -m "updated at `date`"
git push origin master

