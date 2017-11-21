#====================
# 基本設定
#====================

# 日本語を使用
export LANG=ja_JP.UTF-8

# vimキーバインド
bindkey -v

# backspace,deleteキーを使えるように
stty erase ^H
bindkey "^[[3~" delete-char

# コマンドミスを修正
setopt correct

# 開始と終了を記録
setopt EXTENDED_HISTORY

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# Ctrl+rでヒストリーサーチ
bindkey '^r' history-incremental-pattern-search-backward

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000


#====================
# コマンド
#====================

# alias
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias diff='diff -U1'
alias ll='ls -l'
alias la='ls -a'
alias grep='grep --color'
alias ps='ps --sort=start_time'
alias note='jupyter notebook'

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
esac

# コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end


#====================
# 色
#====================

# 配色見やすく
local USERCOLOR=%F{082}
local HOSTCOLOR=%F{006}
local DEFAULT=$'\n'%F{250}'%(!.#.$) '%f
PROMPT=$USERCOLOR'%n@%m '$HOSTCOLOR'[%~]'$DEFAULT


# 色を使用
autoload -Uz colors
colors


#====================
# 補完
#====================

# 補完
autoload -Uz compinit
compinit -C

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


#====================
# git
#====================

# プロンプトへの表示設定
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


#====================
# パス設定
#====================

# ruby
export RBENV_ROOT=~/.rbenv
export PATH="$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH"
if which rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# python
export PYENV_ROOT=~/.pyenv
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
if which pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


#====================
# tmux
#====================

# 起動時に色が変わらないように
export "TERM=xterm-256color"

# 自動起動
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && [ -z $TMUX ] && [ $HOST != "candy" ]; then
  if $(tmux has-session); then
    option="attach"
  fi
  tmux $option && exit
fi
