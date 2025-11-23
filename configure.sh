#!/bin/sh

set -Ceu

readonly BASE_DIR=$(cd -- "$(dirname -- "$0")" > /dev/null 2>&1 && pwd | sed -e "s|$HOME|\~|")

exit_usage() {
  echo "usage: $0 [apply|unapply] [dest_dir]"
  [ $# -ge 1 ] && echo "error: $1"
  exit 1
}

extract_configure() {
  target=$1
  patch=$2
  patched=$(if grep -q "${patch}" "$target" 2>/dev/null; then echo 0; else echo 1; fi)

  if [ "$SUB_CMD" = "apply" ]; then
    mkdir -p "$(dirname -- "$target")" && touch "$target"
    [ $patched -ne 0 ] && echo "${patch}" >> "$target"
  elif [ "$SUB_CMD" = "unapply" ]; then
    if [ $patched -eq 0 ]; then
      # Portable sed -i: create temp file and replace
      sed -e "\:${patch}:d" "$target" > "$target.tmp" && mv "$target.tmp" "$target"
    fi
  else
    exit_usage
  fi

  return 0
}

config_readline() {
  extract_configure ${DEST_DIR:-~/.config/readline}/inputrc "\$include ${BASE_DIR}/inputrc"
  return 0
}

config_tmux() {
  extract_configure ${DEST_DIR:-~/.config/tmux}/tmux.conf "source-file ${BASE_DIR}/tmux.conf"
  return 0
}

config_rcprofile() {
  for f in shrc profile; do
    extract_configure ${DEST_DIR:-~}/$(if [ -z "${DEST_DIR}" ] || [ "$DEST_DIR" = "$HOME" ]; then echo "."; fi)$f "source ${BASE_DIR}/${f}"
  done
  return 0
}

config_vimrc() {
  for f in vimrc gvimrc; do
    extract_configure ${DEST_DIR:-~/.config/vim}/$f "source ${BASE_DIR}/${f}"
  done
  return 0
}

config_nviminit() {
  for f in init.lua ginit.lua; do
    extract_configure ${DEST_DIR:-~/.config/nvim}/$f "vim.cmd('source ${BASE_DIR}/${f}')"
  done
  return 0
}

if [ $# -eq 2 ]; then
  readonly SUB_CMD=$1
  readonly DEST_DIR=$2
# elif [ $# -eq 1 ]; then
#   readonly SUB_CMD=$1
#   readonly DEST_DIR=
else
  exit_usage
fi

case $SUB_CMD in
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