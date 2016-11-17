# 以下のコマンドでzplugをインストールしておくこと.
# curl -sL zplug.sh/installer | zsh

source ~/.zplug/init.zsh

# 入力補完.
zplug "zsh-users/zsh-autosuggestions"
# 候補選択拡張.
zplug "zsh-users/zsh-completions"
# compinit 以降に読み込むようにロードの優先度を変更する（10~19にすれば良い）
zplug "zsh-users/zsh-syntax-highlighting", nice:10
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
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=50000
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
    eval "$(rbenv init -)"
    ;;
  linux*)
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    ;;
esac
