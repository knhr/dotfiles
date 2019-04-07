# The following lines were added by compinstall

zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

autoload colors
colors

# 新しく作られたファイルのパーミッションは 644
umask 022

# core ファイルは作らせない
ulimit -c 0

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# cd -[tab] でpushd
setopt auto_pushd

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups

# Ctrl-d でログアウトしないようにする。
setopt ignore_eof

# globを拡張する。
setopt extended_glob

# 履歴の共有
setopt share_history

# 先頭がスペースならヒストリーに追加しない。
setopt hist_ignore_space

# リダイレクトで上書きする事を許可しない。
setopt no_clobber

# rm * を実行する前に確認される。
setopt rmstar_wait

setopt share_history
setopt list_packed
setopt print_eight_bit
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_ignore_all_dups
setopt numeric_glob_sort

# workaround for WSL
# 'nice' does not work for background processes in WSL
# https://github.com/Microsoft/WSL/issues/1887
unsetopt BG_NICE

# 前方一致で補完候補を絞り込んで補完する
# bindkey '^P' history-beginning-search-backward
# bindkey '^N' history-beginning-search-forward

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# zaw: incremental history search like helm.el
source ${HOME}/.zsh.d/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes
bindkey '^X]' zaw-cdr
bindkey '^]' zaw-history

# prompt settings
PROMPT="%% "
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
RPROMPT="%{${fg[green]}%}%/%{${reset_color}%}"

# alias settings
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls -F"
alias lv="lv -Ou8"
alias lgrep="lgrep -Ou8 -Ku8"

function SumatraPDF() {
  cmd.exe /c "c:/Program Files/SumatraPDF/SumatraPDF.exe" $1 >& /dev/null &
}

load_if_exists () {
    if [ -e $1 ]; then
        source $1
    fi
}

# start tmux if not exist
if [[ ! -n $TMUX ]]; then
  tmux new-session
fi

### start ssh-agent
SSH_AGENT_FILE=$HOME/.ssh-agent
load_if_exists $SSH_AGENT_FILE
ssh-add -l > /dev/null 2>&1
if [ $? -eq 2 ]; then
  echo -n "ssh-agent: (re)start...."
  ssh-agent >! $SSH_AGENT_FILE
  source $SSH_AGENT_FILE
fi

ssh-add -l > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "ssh-agent: Identity is already stored."
else
  ssh-add $HOME/.ssh/id_rsa
fi
