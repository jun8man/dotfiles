# users generic .zshrc file for zsh(1)

#------------------------
# 履歴設定
#------------------------
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=50000
function history-all { history -E 1 } # 全履歴の一覧を出力する
setopt share_history                  # 履歴の共有化

# ビープ音無効
# ビープ音うるさいので無効
setopt nolistbeep

#------------------------
# プロンプト
#------------------------
# prompt
#autoload -U colors
#colors
# %n ユーザ名
# %m ホスト名
# %d ディレクトリ名
PROMPT='[%F{5}%d%f]
%F{3}%n@%m%f# '
# setopt transient_rprompt

#-----------------------
# シェル変数周り
#-----------------------
setopt  auto_list               # 自動的に候補一覧を表示
setopt  auto_menu               # 自動的にメニュー補完する
setopt  auto_param_keys         # 変数名を補完する
# setopt  rm_star_silent          # "rm * " を実行する前に確認 しない
setopt no_flow_control         # C-s/C-q によるフロー制御をしない
setopt AUTO_PUSHD               # 自動で pushd (cd でも、pushd)
setopt PUSHD_IGNORE_DUPS        # pushd の 重複排除
setopt EXTENDED_GLOB            # 強力なグロッピング

#-----------------------
# 補完関係
#-----------------------
# デフォルトの補完機能を有効
autoload -U compinit
compinit

# 補完侯補をEmacsのキーバインドで動き回る
zstyle ':completion:*:default' menu select=1

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#for zsh-completions
case $OSTYPE in
    darwin*)
        fpath=(/usr/local/share/zsh-completions $fpath)
        # 有効にする
        autoload -Uz compinit
        compinit -u
        ;;
esac

#------------------------
# key bind
#------------------------
case $OSTYPE in
    cygwin*)
        #### DELETE key
        bindkey "^[[3~" delete-char
        #### HOME key
        bindkey "^[[1~" beginning-of-line
        #### END key
        bindkey "^[[4~" end-of-line
        ;;
esac

#------------------------
# エイリアス
#------------------------
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
    linux*)
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

# export PATH
# PAtH=/cygdrive/c/emacs-24.3/bin/:$PATH
# export PATH

export LANG=ja_JP.UTF-8
# export LANG=ja_JP.SJIS
# export JLESSCHARSET=japanese-sjis
# export OUTPUT_CHARSET=sjis

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

case $OSTYPE in
  darwin*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    ;;
  cygwin*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    ;;
  linux*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    ;;
esac

