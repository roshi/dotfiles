#/usr/bin/env bash

set -Ceux
WORK_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd | sed -e "s|$HOME|\~|")

applying() {
  [ $subcommand == "apply" ]
}

unapplying() {
  [ $subcommand == "unapply" ]
}

exit_usage() {
  echo "usage: $0 [apply|unapply]"
  [ ! -z "$1" ] && echo "error: $1"
  exit 1
}

assume_rcprofile() {
  if [ -z "$1" ]; then
    exit_usage "assume_rcprofile: missing argument"
  fi
  if [ "$1" == "profile" ]; then
    echo $1
    return
  fi

  if [ -n "$BASH_VERSION" ]; then
    echo "ba$1"
  elif [ -n "$ZSH_VERSION" ]; then
    echo "z$1"
  else
    exit_usage "unknown shell"
  fi
}

config_readline() {
  target=~/.config/readline/inputrc
  patch="\$include ${WORK_DIR}/inputrc"
  patched=$(grep -q "${patch}" $target &> /dev/null; echo $?)

  if applying; then
    mkdir -p $(dirname -- $target)
    [ $patched -ne 0 ] && echo "${patch}" >> $target
  elif unapplying; then
    [ $patched -eq 0 ] && sed -i "\:${patch}:d" $target
  else
    exit_usage
  fi

  return 0
}

config_tmux() {
  target=~/.config/tmux/tmux.conf
  patch="source-file ${WORK_DIR}/tmux.conf"
  patched=$(grep -q "${patch}" $target &> /dev/null; echo $?)

  if applying; then
    mkdir -p $(dirname -- $target)
    [ $patched -ne 0 ] && echo "${patch}" >> $target
  elif unapplying; then
    [ $patched -eq 0 ] && sed -i "\:${patch}:d" $target
  else
    exit_usage
  fi

  return 0
}

config_rcprofile() {
  for f in shrc profile; do
    target=~/.$(assume_rcprofile $f)
    patch="source ${WORK_DIR}/${f}"
    patched=$(grep -q "${patch}" $target &> /dev/null; echo $?)

    if applying; then
      [ $patched -ne 0 ] && echo "${patch}" >> $target
    elif unapplying; then
      [ $patched -eq 0 ] && sed -i "\:${patch}:d" $target
    else
      exit_usage
    fi
  done

  return 0
}

config_vimrc() {
  for f in vimrc gvimrc; do
    target=~/.config/vim/$f
    patch="source ${WORK_DIR}/${f}"
    patched=$(grep -q "${patch}" $target &> /dev/null; echo $?)
  
    if applying; then
      mkdir -p $(dirname -- $target)
      [ $patched -ne 0 ] && echo "${patch}" >> $target
    elif unapplying; then
      [ $patched -eq 0 ] && sed -i "\:${patch}:d" $target
    else
      exit_usage
    fi
  done

  return 0
}

config_nviminit() {
  for f in init.lua ginit.lua; do
    target=~/.config/nvim/$f
    patch="vim.cmd('source ${WORK_DIR}/${f}')"
    patched=$(grep -q "${patch}" $target &> /dev/null; echo $?)
  
    if applying; then
      mkdir -p $(dirname -- $target)
      [ $patched -ne 0 ] && echo "${patch}" >> $target
    elif unapplying; then
      [ $patched -eq 0 ] && sed -i "\:${patch}:d" $target
    else
      exit_usage
    fi
  done

  return 0
}

if [ $# -ne 1 ]; then
  exit_usage
fi
subcommand="$1"
shift

case $subcommand in
  "apply")
    config_readline
    config_tmux
    config_rcprofile
    config_vimrc
    config_nviminit
    ;;
  "unapply")
    config_nviminit
    config_vimrc
    config_rcprofile
    config_tmux
    config_readline
    ;;
  *)
    exit_usage
    ;;
esac
