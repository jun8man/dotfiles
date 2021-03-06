# .zplugが存在しなければインストールする.
if [ ! -d ~/.zplug ]; then
    echo `curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh`
    touch ~/.zplug/last_zshrc_check_time
fi

source ~/.zplug/init.zsh

# 入力補完.
zplug "zsh-users/zsh-autosuggestions"
# 候補選択拡張.
zplug "zsh-users/zsh-completions"
# compinit 以降に読み込むようにロードの優先度を変更する（0..3）
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# peco/fzf/percol/zawなどのラッパー関数を提供するFW的なもの.
zplug "mollifier/anyframe"
# 移動強化系plugin.
zplug "b4b4r07/enhancd", use:enhancd.sh
# ヒストリーサーチを便利に.
zplug "zsh-users/zsh-history-substring-search", hook-build:"__zsh_version 4.3"
# コマンドライン出力結果のインクリメントサーチ.
case $OSTYPE in
    darwin*)
        zplug "peco/peco", as:command, from:gh-r
    ;;
esac

# Pluginのチェックとインストール.
# .zxhrcに更新がなければチェックしない.
if [ ~/.zplug/last_zshrc_check_time -ot ~/GitRepos/dotfiles/zsh/.zshrc ]; then
    touch ~/.zplug/last_zshrc_check_time
    if ! zplug check --verbose; then
      printf 'Install? [y/N]: '
      if read -q; then
        echo; zplug install
      fi
    fi
fi

zplug load --verbose

HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=500000
# 全履歴の一覧を出力する.
function history-all { history -E 1 }
# 履歴の共有化.
setopt share_history
# ビープ音無効.
setopt nolistbeep
# prompt.
# %n ユーザ名.
# %m ホスト名.
# %d ディレクトリ名.
PROMPT='[%F{5}%d%f]
%F{3}%n@%m%f# '
# vesion control systems の infoを追加.
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'
# 補完侯補をEmacsのキーバインドで動き回る.
zstyle ':completion:*:default' menu select=1
# 補完の時に大文字小文字を区別しない.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# キーバインド.
case $OSTYPE in
    cygwin*)
        #### DELETE key.
        bindkey "^[[3~" delete-char
        #### HOME key.
        bindkey "^[[1~" beginning-of-line
        #### END key.
        bindkey "^[[4~" end-of-line
        ;;
esac
# エイリアス.
case $OSTYPE in
    darwin*)
        alias ls='ls -FG'
        alias ll='ls -al'
        alias myctags='/usr/local/bin/ctags -R -f'
        ;;
    cygwin*)
        alias vi='/usr/bin/vim'
        alias ls='ls -F --color=auto'
        alias ll='ls -al'
        alias st="c:/Program\ Files/Sublime\ Text\ 3/sublime_text.exe"
        alias ipconfig='ipconfig | nkf -w'
        alias ifconfig='ipconfig | nkf -w'
        alias grep='grep -iE --color=auto'
        alias wm='c:/Program\ Files/WinMerge/WinMergeU.exe'
        alias ping='cocot ping'
        ;;
    msys*)
        alias vi='/usr/bin/vim'
        alias ls='ls -F --color=auto'
        alias ll='ls -al'
        alias subl="c:/Program\ Files/Sublime\ Text\ 3/sublime_text.exe"
        alias ipconfig='ipconfig | nkf -w'
        alias ifconfig='ipconfig | nkf -w'
        alias grep='grep -iE --color=auto'
        alias wm='c:/Program\ Files/WinMerge/WinMergeU.exe'
        alias ping='cocot ping'
	;;
    linux*)
        alias ls='ls -F --color=auto'
        alias ll='ls -al'
        alias ifconfig='ipconfig | nkf -w'
        alias grep='grep -iE --color=auto'
        alias ping='cocot ping'
        ;;
esac
# プロンプトのカラー表示を有効
case $OSTYPE in
    darwin*)
        # Nothing.
        ;;
    cygwin*)
        source ~/GitRepos/mintty-colors-solarized/sol.dark
        ;;
esac
# 文字コード.
export LANG=ja_JP.UTF-8

# proxy
# export HTTP_PROXY=http://proxy.rmt.sony.co.jp:10080
# export HTTPS_PROXY=$HTTP_PROXY
# export FTP_PROXY=$HTTP_PROXY
# export NO_PROXY="127.0.0.1,localhost,192,168.*,git.example.com"

# ssh-agent 用
case $OSTYPE in
    cygwin*)
        agentPID=`ps gxww|grep "ssh-agent]*$"|awk '{print $1}'`
        agentSOCK=`/bin/ls -t /tmp/ssh*/agent*|head -1`
        if [ "$agentPID" = "" -o "$agentSOCK" = "" ]; then
            unset SSH_AUTH_SOCK SSH_AGENT_PID
            eval `ssh-agent`
        else
            export SSH_AGENT_PID=$agentPID
            export SSH_AUTH_SOCK=$agentSOCK
        fi
        ;;
esac
# rbenv.
case $OSTYPE in
  darwin*)
#    export PATH="$HOME/.rbenv/bin:$PATH"
#    eval "$(rbenv init -)"
    ;;
  cygwin*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    if type rbenv > /dev/null 2>&1; then
        eval "$(rbenv init -)"
    fi
    ;;
  linux*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    ;;
esac

# java
case $OSTYPE in
  darwin*)
#    export PATH="$HOME/.rbenv/bin:$PATH"
#    eval "$(rbenv init -)"
    ;;
  cygwin*)
    if [ -e /cydrive/C/Program\ Files/Java/jre1.8.0_151/bin ]; then
       export PATH=$PATH:"/cydrive/C/Program Files/Java/jre1.8.0_151/bin:"
    fi
   ;;
  linux*)
#    export PATH="$HOME/.rbenv/bin:$PATH"
#    eval "$(rbenv init -)"
#    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    ;;
esac

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# zsh起動速度チェック用.
# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi
