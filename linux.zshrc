export PACMAN=pacman-color
export BROWSER=google-chrome:firefox:$BROWSER
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin
export PATH=/usr/lib/colorgcc/bin:$PATH

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

function sshi(){
    ssh -i $HOME/.ssh/id_rsa r-hayashida@$1
}

alias x=startx
alias configawesome='vim $HOME/.config/awesome/rc.lua'

# suffix alias
alias -s pdf='xpdf'
alias -s html='google-chrome'
alias -s plt='gnuplot'
