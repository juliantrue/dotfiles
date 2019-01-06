#!/bin/sh

# Detect if OS is a MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "MacOS detected, proceeding with MacOS install.sh"
  brew="/usr/local/bin/brew"
  if [ -f "$brew" ]
  then
    echo "Homebrew is installed, nothing to do here"
  else
    echo "Homebrew is not installed, installing now"
    echo "This may take a while"
    echo "Homebrew requires osx command lines tools, please download xcode first"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  fi

  packages=(
  "git"
  "tmux"
  "neovim"
  "python"
  "python2"
  )

  for i in "${packages[@]}"
  do
    brew install $i
    echo "---------------------------------------------------------"
  done

  echo "installing pynvim"
  pip2 install pynvim
  pip3 install pynvim

  echo "installing RCM, for dotfiles management"
  brew tap thoughtbot/formulae
  brew install rcm
  echo "---------------------------------------------------------"

  localGit="/usr/local/bin/git"
  if [ -f "$localGit" ]
  then
    echo "git is all good"
  else
    echo "git is not installed"
  fi
  # Okay so everything should be good at this point to proceed
  # Fingers crossed
  # Now lets clone my dotfiles repo into .dotfiles/
  echo "---------------------------------------------------------"

  echo "Cloning dotfiles into .dotfiles"
  git clone https://github.com/juliantrue/dotfiles.git ~/.dotfiles

  cd .dotfiles
  git submodule update --init --recursive

  cd $HOME
  echo "running RCM's rcup command"
  echo "This is symlink the rc files in .dofiles"
  echo "with the rc files in $HOME"
  echo "---------------------------------------------------------"

  rcup

  echo "---------------------------------------------------------"
  echo "You'll need to log out for this to take effect"
  echo "---------------------------------------------------------"

  echo "---------------------------------------------------------"
  echo "All done!"
  echo "and change your terminal font to source code pro"
  echo "Cheers"
  echo "---------------------------------------------------------"

# Detect if OS is linux
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "Linux-GNU detected, proceeding with Linux-GNU install.sh"

  packages=(
  "git"
  "tmux"
  "neovim"
  )

  for i in "${packages[@]}"
  do
    sudo apt-get install $i
    echo "---------------------------------------------------------"
  done

  echo "installing pynvim"
  pip install pynvim
  pip3 install pynvim

  echo "installing RCM, for dotfiles management"
  sudo apt-get install thoughtbot/formulae
  echo "---------------------------------------------------------"

  localGit="/usr/local/bin/git"
  if [ -f "$localGit" ]
  then
    echo "git is all good"
  else
    echo "git is not installed"
  fi
  # Okay so everything should be good at this point to proceed
  # Fingers crossed
  # Now lets clone my dotfiles repo into .dotfiles/
  echo "---------------------------------------------------------"

  echo "Cloning dotfiles into .dotfiles"
  git clone https://github.com/juliantrue/dotfiles.git ~/.dotfiles

  cd .dotfiles
  git submodule update --init --recursive

  cd $HOME
  echo "running RCM's rcup command"
  echo "This is symlink the rc files in .dofiles"
  echo "with the rc files in $HOME"
  echo "---------------------------------------------------------"

  rcup

  echo "---------------------------------------------------------"
  echo "You'll need to log out for this to take effect"
  echo "---------------------------------------------------------"

  echo "---------------------------------------------------------"
  echo "All done!"
  echo "and change your terminal font to source code pro"
  echo "Cheers"
  echo "---------------------------------------------------------"
fi

exit 0
