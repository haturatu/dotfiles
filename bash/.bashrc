#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias gemini="/usr/bin/gemini"

# alias ls='ls --color=auto'
# alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
# export XMODIFIERS=@im=fcitx5

export LANG=ja_JP.UTF-8

export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export LANG=ja_JP.UTF-8

#xinput set-prop "ETPS/2 Elantech TrackPoint" "libinput Scroll Method Enabled" 0 0 1

# Enable scroll with TrackPoint
if [ ! -z "$DISPLAY" ]; then
    DEVICE="ETPS/2 Elantech TrackPoint"
    PROP="libinput Scroll Method Enabled"

    CURRENT=$(xinput list-props "$DEVICE" | grep "$PROP" | awk '{print $5,$6,$7}')

    if [ "$CURRENT" != "0 0 1" ]; then
        xinput set-prop "$DEVICE" "$PROP" 0 0 1
    fi
fi

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

pp64g() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: pp64g <string> <filename>"
    return 1
  fi

  if [[ ! -d ~/.pp64 ]]; then
    mkdir -p ~/.pp64
  fi

  if [[ -f ~/.pp64/$2 ]]; then
    cat ~/.pp64/$2 | base64 | tr -d "\n" ; echo
  fi

  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p > ~/.pp64/$2
}

cc() {
  echo -n "$1" | base64 |tr -d "\n" && echo
}

ghelp() {
 (echo "これを説明して" ; cat $1 ) | gemini
}

greadme() {
 (echo "Please create a README based on this code. Please output in raw format text using markdown." ; cat "$1"; cat $2; cat $3 ) | gemini
}

_ssh_hosts() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(awk '{print $1}' ~/.ssh/known_hosts | cut -d, -f1 | sort -u)" -- "$cur") )
}
complete -F _ssh_hosts ssh

crontab() {
  if [ "$1" = "-r" ]; then
    echo "NOT ALLOWED"
    return 1
  fi
}

mkr() {
  if [ -z "$1" ]; then
    echo "Usage: mkr <repository-name>"
    return 1
  fi
  GIT_SERVER="git@conoha-freebsd"
  ssh $GIT_SERVER "git init --bare repos/$1.git"
  ssh $GIT_SERVER "cd repos/$1.git; git branch -m main"
  echo "remote add origin $GIT_SERVER:~/repos/$1.git"
}

alias yt4="yt-dlp --merge-output-format mp4"

export PATH="/home/haturatu/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(rbenv init -)"

export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
