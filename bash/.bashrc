#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
# alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
#export XMODIFIERS=@im=fcitx5
export LANG=ja_JP.UTF-8

export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export LANG=ja_JP.UTF-8

xinput set-prop 11 "libinput Scroll Method Enabled" 0 0 1
xinput set-prop 11 "libinput Button Scrolling Button" 2

pp() {
  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p | base91 |tr -d "\n" && echo
}

pp20() {
  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p | base91 | cut -c -20 | tr -d "\n" && echo
}

pp20g() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: pp20g <string> <filename>"
    return 1
  fi

  if [[ ! -d ~/.pp20 ]]; then
    mkdir -p ~/.pp20
  fi

  if [[ -f ~/.pp20/$2 ]]; then
    cat ~/.pp20/$2 | base91 | cut -c -20 | tr -d "\n" ; echo
  fi

  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p > ~/.pp20/$2
}

cc() {
  echo -n "$1" | base91 |tr -d "\n" && echo
}

ghelp() {
 (echo "これを説明して" ; cat $1 ) | gemini
}

alias yt4="yt-dlp --merge-output-format mp4"

export PATH="/home/haturatu/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
