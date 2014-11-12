export PACMAN=pacman-color
export BROWSER=google-chrome:firefox:$BROWSER
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin
export PATH=/usr/lib/colorgcc/bin:$PATH

# for Tmux 256 bit color
if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
fi

# Go
if [ -d "/usr/local/go" ]; then
    export GOROOT=/usr/local/go
    if [ ! -d "$HOME/.go" ]; then
        mkdir -p $HOME/.go
    fi
    export GOPATH=$HOME/.go
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

# Arch Linux environment
if which pacman > /dev/null; then

    alias pacman=pacman-color
    alias -g pacu='pacman -Syu'
    alias -g pac='pacman -S'
    pacs(){
        echo "local repos:"
        pacman -Qs ${@:1}
        echo
        echo "remote repos:"
        pacman -Ss ${@:1}
    }
    paci(){
        echo "local repos:"
        pacman -Qi ${@:2}
        echo
        echo "remote repos:"
        pacman -Si ${@:2}
        echo ${@:2}
    }
    alias -g pacr='pacman -Rsn'

    alias yao='yaourt -S'
    alias -g yaou='yaourt -Syu'
    yaos(){
        echo "local repos:"
        yaourt -Qs ${@:1}
        echo
        echo "remote repos:"
        yaourt -Ss ${@:1}
    }
    yaoi(){
        echo "local repos:"
        yaourt -Qi ${@:2}
        echo
        echo "remote repos:"
        yaourt -Si ${@:2}
        echo ${@:2}
    }
    alias -g yaor='yaourt -Rsn'
    alias -s pdf='zathura'
    function sshi(){
}
fi

if which awesome > /dev/null; then
    alias configawesome='vim $HOME/.config/awesome/rc.lua'
fi

alias x=startx
alias gp=gnuplot
alias xo=xdg-open

# suffix alias
alias -s html='google-chrome'
alias -s plt='gnuplot'
alias -s plot='gnuplot'

if which xsel > /dev/null; then
    alias -g C='| xsel --input --clipboard'
fi

# global alias
if which notify-send > /dev/null; then
    alias -g BG=' 2>&1 | notify-send &'
fi

# cleverer umount command
if ! which um > /dev/null; then
    function um(){
        local dirs_in_media
        dirs_in_media=$(ls -l /media/ | grep -e ^d)
        if [[ "$(echo "$dirs_in_media" | wc -l)" == 1 ]]; then
            local media_dir
            media_dir=${"$(echo "$dirs_in_media" | head -n 1)"##* }
            echo -n "unmounting ${media_dir}... "
            umount $@ /media/"$media_dir"
            $? && echo "done."
        else
            umount $@
        fi
    }
fi

# vim: set ft=zsh fdm=marker ff=unix fileencoding=utf-8:
