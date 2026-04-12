#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='[\u@\h \W]\$ '
PS1='\[\033[1;32;40m\]\h\[\033[0;37;40m\]:\[\033[31;40m\][\[\033[1;34;40m\]\u\[\033[0;31;40m\]]\[\033[0;37;40m\]:\[\033[35;40m\]\w\[\033[1;33;40m\]\n$\[\033[0m\] '
alias ls='ls --color=auto'
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"
alias gemini="/usr/bin/gemini"
alias yt4="yt-dlp --merge-output-format mp4"

alias gp="git pull"
alias gpo="git push origin"

export LANG=ja_JP.UTF-8
export HISTSIZE=1000
export HISTFILESIZE=2000

export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export LANG=ja_JP.UTF-8
export EDITOR="vim"

# Enable scroll with TrackPoint(ThinkPad)
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

pp2091g() {
  local dir="$HOME/.$FUNCNAME"
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $FUNCNAME <string> <filename>"
    return 1
  fi

  if [[ ! -d $dir ]]; then
    mkdir -p $dir
  fi

  if [[ -f $dir/$2 ]]; then
    cat $dir/$2 | base91 | cut -c -20 | tr -d "\n" ; echo
    return 0
  fi

  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p > $dir/$2
  echo "Generated and saved to $dir/$2"
}

pp6464g() {
  local dir="$HOME/.$FUNCNAME"
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $FUNCNAME <string> <filename>"
    return 1
  fi

  if [[ ! -d $dir ]]; then
    mkdir -p $dir
  fi

  if [[ -f $dir/$2 ]]; then
    cat $dir/$2 | base64 | tr -d "\n" ; echo
    return 0
  fi

  echo -n "$1" | sha384sum | awk '{print $1}' | xxd -r -p > $dir/$2
  echo "Generated and saved to $dir/$2"
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
  COMPREPLY=(
    $(
      compgen -W "$(
        {
          awk '{print $1}' ~/.ssh/known_hosts | cut -d, -f1
          grep '^Host ' ~/.ssh/config | awk '{print $2}'
        } | sort -u
      )" -- "$cur"
    )
  )
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

nproxy() {
  if [ -z "$1" ]; then
    echo "Usage: nproxy <port>"
    return 1
  fi

  local PORT=$1
  local NGINX_CONF="/etc/nginx/site/proxy.conf"
  local NOW_PORT=$(grep -oP ':[0-9]+' $NGINX_CONF | uniq)
  local INIT_SERVICE="rc-service"

  sudo sed -i "s/$NOW_PORT/:$PORT/g" $NGINX_CONF
  sudo $INIT_SERVICE nginx restart
  echo "nginx restarted. $NOW_PORT -> :$PORT"
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init --path)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# Cargo, Go, Pyenv, Rbenv
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Android SDK, Java, and pppbash
source /usr/local/sh/$USER/ppbash.sh 2>/dev/null || true
export PATH=$JAVA_HOME/bin:$PATH
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/

eval "$(hl completion bash)" # hl-cli-completion
