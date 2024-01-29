#/bin/sh

# ./configure.sh apply ~
# ./configure.sh unapply ~

set -Ceux

BASE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &> /dev/null && pwd | sed -e "s|$HOME|\~|")
DEST_DIR=

exit_usage() {
  echo "usage: $0 [apply|unapply] dest_dir"
  [ $# -ge 1 ] && echo "error: $1"
  exit 1
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
  extract_configure ${DEST_DIR:-~/.config/readline}/inputrc "\$include ${BASE_DIR}/inputrc"
  return 0
}

config_tmux() {
  extract_configure ${DEST_DIR:-~/.config/tmux}/tmux.conf "source-file ${BASE_DIR}/tmux.conf"
  return 0
}

config_rcprofile() {
  if [ -n "${BASH_VERSION+x}" ]; then
    sh="bash"
  elif [ -n "${ZSH_VERSION+x}" ]; then
    sh="zsh"
  else
    exit_usage "unknown shell"
  fi

  for f in shrc profile; do
    if [[ $sh = "bash" && $f = "profile" ]]; then
      target=.${f}
    else
      target=.${sh:0:${#sh}-2}${f}
    fi
    extract_configure ${DEST_DIR:-~}/$target "source ${BASE_DIR}/${f}"
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

if [ $# -ne 2 ]; then
  exit_usage
fi
subcommand=$1
shift
DEST_DIR=$1
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