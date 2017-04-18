# 配色見やすく
case "$OSTYPE" in
  linux*)
    local USERCOLOR=%F{082}
    local HOSTCOLOR=%F{006}
    ;;
  cygwin*)
    local USERCOLOR=%F{162}
    local HOSTCOLOR=%F{208}
    ;;
esac
local DEFAULT=$'\n'%F{250}'%(!.#.$) '%f
#PROMPT=$'\n'$USERCOLOR'%n@%m '$HOSTCOLOR'[%~]'$'\n'$DEFAULT'%(!.#.$) '
PROMPT=$USERCOLOR'%n@%m '$HOSTCOLOR'[%~]'$DEFAULT

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
RPROMPT="%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{220}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{009}+"
zstyle ':vcs_info:*' formats "%F{002}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# envの保存位置
# vmの場合
if vmware-toolbox-cmd -v > /dev/null 2>&1
then
  env_path=/usr/local
# それ以外
else
  env_path=$HOME
fi

# ruby設定
export RBENV_ROOT=$env_path/.rbenv
export PATH="$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH"
if which rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# python設定
export PYENV_ROOT=$env_path/.pyenv
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
if which pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# tmux起動時に色が変わらないように
export "TERM=xterm-256color"

# tmux自動起動
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | $PERCOL | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi

#profile
#if type zprof > /dev/null 2>&1; then
#  zprof  | less
#fi
