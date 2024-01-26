#/bin/sh

set -Ceux
BASE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &> /dev/null && pwd | sed -e "s|$HOME|\~|")

exit_usage() {
  echo "usage: $0 [apply|unapply]"
  [ $# -ge 1 ] && echo "error: $1"
  exit 1
}

assume_shell() {
  if [ -n "${BASH_VERSION+x}" ]; then
    echo "bash"
  elif [ -n "${ZSH_VERSION+x}" ]; then
    echo "zsh"
  else
    exit_usage "unknown shell"
  fi
}

extract_configure() {
  target=$1
  patch=$2
  patched=$(if grep -q "${patch}" $target &> /dev/null; then echo 0; else echo 1; fi)

  if [ $subcommand = "apply" ]; then
    mkdir -p $(dirname -- $target) && touch $target
    [ $patched -ne 0 ] && echo "${patch}" >> $target
  elif [ $subcommand = "unapply" ]; then
    [ $patched -eq 0 ] && sed -i '' -e "\:${patch}:d" $target
  else
    exit_usage
  fi

  return 0
}

config_readline() {
  extract_configure ~/.config/readline/inputrc "\$include ${BASE_DIR}/inputrc"
  return 0
}

config_tmux() {
  extract_configure ~/.config/tmux/tmux.conf "source-file ${BASE_DIR}/tmux.conf"
  return 0
}

config_rcprofile() {
  sh=$(assume_shell)
  for f in profile shrc; do
    extract_configure ~/.$(if [ $f = "shrc" ]; then echo ${sh:0:${#sh}-2}; fi)$f "source ${BASE_DIR}/${f}"
  done
  return 0
}

config_vimrc() {
  for f in vimrc gvimrc; do
    extract_configure ~/.config/vim/$f "source ${BASE_DIR}/${f}"
  done
  return 0
}

config_nviminit() {
  for f in init.lua ginit.lua; do
    extract_configure ~/.config/nvim/$f "vim.cmd('source ${BASE_DIR}/${f}')"
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