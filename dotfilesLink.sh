#! /bin/bash

export FILENAME=$(basename $0)

# usage
function usage {
  cat <<-EOF
  $FILENAME makes dotfiles as symbolic link.

  Usage:
    $FILENAME [os type] [<options>]

  Os type:
    osx   for mac os
    win   for windows os

  Options:
    --version, -v   print $FILENAME version
    --help, -h      print this
EOF
}

function version {
  echo "$FILENAME version 0.0.1"
}

function link {
  ln -s ~/Work/Repos/dotfiles/$1/vim/.vimrc ~/.vimrc
  ln -s ~/Work/Repos/dotfiles/$1/vim/.vim/ ~/.vim
  ln -s ~/Work/Repos/dotfiles/$1/zsh/.zshrc ~/.zshrc
  ln -s ~/Work/Repos/dotfiles/$1/git/.gitconfig ~/.gitconfig
  ln -s ~/Work/Repos/dotfiles/$1/git/.gitignore ~/.gitignore
  echo "finished."
}

case $1 in
  osx | win)
    link $1
  ;;

  --version | -v)
    version
  ;;

  --help | -h)
    usage
  ;;

  *)
    echo "[ERROR] Invalid subcommand $1"
    usage
    exit 1
  ;;
esac
