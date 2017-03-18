# http://qiita.com/d-dai/items/d7f329b7d82e2165dab3から拝借
# 配色見やすく
case "$OSTYPE" in
  cygwin*)
    local USERCOLOR=$'%{\e[1;32m%}'
    ;;
  linux*)
    local USERCOLOR=$'%{\e[1;36m%}'
    ;;
esac
local HOSTCOLOR=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
PROMPT=$'\n'$USERCOLOR'${USER}@ '$HOSTCOLOR'[${HOSTNAME}% ]'$'\n'$DEFAULT'%(!.#.$) '

# 日本語を使用
export LANG=ja_JP.UTF-8

# 色を使用
autoload -Uz colors
colors

# 補完
autoload -Uz compinit
compinit -C

# vimキーバインド
bindkey -v

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# コマンドミスを修正
setopt correct

# 開始と終了を記録
setopt EXTENDED_HISTORY

# historyに日付を表示
alias h='fc -lt '%F %T' 1'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='cd ../'
alias back='pushd'
alias diff='diff -U1'

# backspace,deleteキーを使えるように
stty erase ^H
bindkey "^[[3~" delete-char

# cdの後にlsを実行
chpwd() { ls --color=auto }

# lsの自動カラー表示設定
case "${OSTYPE}" in
darwin*)
 # Mac
 alias ls="ls -GF"
 ;;
linux*)
 # Linux
 alias ls='ls --color'
 ;;
cygwin*)
 #ucygwin
 alias ls='ls --color'
 ;;
esac

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# git設定
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# powerline
#case ${OSTYPE} in
#  cygwin*)
#  #source fonts/sol.dark
#  ;;
#  linux*)
#  powerline-daemon -q
#  . ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
#  ;;
#esac

# ruby設定
case ${OSTYPE} in
  linux*)
# eval "$(rbenv init - zsh)"
# ↓ 代用(rbenv rehash をしない)
  export RBENV_ROOT=/usr/local/.rbenv
  export PATH="${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
  ;;
  cygwin*)
  ;;
esac

# python設定
case ${OSTYPE} in
  linux*)
  export PYENV_ROOT=/usr/local/.pyenv
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  ;;
esac

# tmux起動時に色が変わらないように
export "TERM=xterm-256color"

# プロンプトの改行

#profile
#if type zprof > /dev/null 2>&1; then
#  zprof  | less
#fi
