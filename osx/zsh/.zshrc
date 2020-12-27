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
zplug "peco/peco", as:command, from:gh-ra

zplug "Tarrasch/zsh-autoenv"

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

# エイリアス.
alias ls='ls -FG'
alias ls='exa -aF'
alias ll='exa -alF'
alias myctags='/usr/local/bin/ctags -R -f'
# alias portforward='ssh -i ~/.ssh/id_rsa_portforward -L 13389:43.2.130.31:3389 jyamashita@43.2.136.60'
# alias pfw='ssh -l jyamashita pfw.jp.sie.sony.com -i ~/.ssh/id_rsa_new_portforward -L 13389:43.2.130.31:3389'
alias pfw='ssh -l jyamashita pfw.jp.sie.sony.com -i ~/.ssh/id_rsa_new_portforward -L 13389:JPC00175053.jp.sony.com:3389'
alias proxy2='ssh -i ~/.ssh/id_rsa_portforward -L 10080:proxy2.hq.scei.sony.co.jp:10080 jyamashita@43.2.136.60'
alias proxyon='source ~/.switch_proxy set'
alias proxyoff='source ~/.switch_proxy unset'
alias ras='sudo openconnect --user=0000132382 --cafile=/Users/yamajun/Documents/Env/RAS/Sony\ Intranet\ CA\ 2.pem rasgw.sony.net'

# 文字コード.
export LANG=ja_JP.UTF-8

# java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
PATH=${JAVA_HOME}/bin:${PATH}

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# git userの設定(repository毎)
function gituser-personal {
  git config user.name "nujamay"
  git config user.email "junya0220yamashita@gmail.com"
  git config --list
}

function gituser-company {
  git config user.name "jun-yamashita"
  git config user.email "Junya.Yamashita@sony.com"
  git config --list
}
