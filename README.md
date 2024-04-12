dotfiles
==========

1. clone dotfiles

   ```
   git clone https://github.com/roshi/dotfiles.git
   ```

2. create directory

   ```
   mkdir -p ~/.cache
   mkdir -p ~/.config
   mkdir -p ~/.local/{share,state}
   ```

3. apply files

   ```
   ./dotfiles/configure.sh apply ~
   ```

4. unapply files

   ```
   ./dotfiles/configure.sh unapply ~
   ```

misc
==========

- install with the command below & set font for terminal.app to NesloLGS Nerd Font Mono Regular 12

   ```
   brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font
   ```

- tidy merged local branches

  ```
  git config --global alias.tidy "git fetch -p && git branch -vv | grep 'origin/.*: gone]' | awk '{ print $1 }' | xargs git branch -D"
  ```
