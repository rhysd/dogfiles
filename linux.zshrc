export PACMAN=pacman-color
export BROWSER=google-chrome:firefox:$BROWSER
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin
export PATH=/usr/lib/colorgcc/bin:$PATH

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
  alias -s pdf='apvlv'
fi

# Debian development
if which apt-get > /dev/null; then
  export LANG=ja_JP.UTF-8
  export TERM=xterm-256color
  export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
  alias synergy='synergyc r-hysd-arch'
  alias -s pdf='acroread'
fi
function sshi(){
ssh -i $HOME/.ssh/id_rsa r-hayashida@$1
}

if which awesome > /dev/null; then
  alias configawesome='vim $HOME/.config/awesome/rc.lua'
  alias apt-up='sudo apt-get update && sudo apt-get upgrade'
fi

alias x=startx
alias gp=gnuplot
alias scpi='scp -i $HOME/.ssh/id_rsa'

# suffix alias
alias -s html='google-chrome'
alias -s plt='gnuplot'
alias -s plot='gnuplot'
