#!/bin/bash

set -e # Exit on any error

echo "---------------------------------------------------------"
echo "Installing:"
echo "    _____  _________  _          ______          _"
echo "   |_   _||  _   _  || |       .' ____ \        / |_"
echo "     | |  |_/ | | \_|\_|.--.   | (___ \_| .---.\`| |-'__   _  _ .--."
echo " _   | |      | |      ( (\`\\]   _.____\`. / /__\\ | | [  | | |[ '/'\`\ \\"
echo "| |__' |     _| |_      \`'.'.  | \____) || \__.,| |, | \_/ |,| \__/ |"
echo "\`.____.'    |_____|    [\__) )  \______.' '.__.'\__/ '.__.'_/| ;.__/"
echo "                                                             [__|"
echo "---------------------------------------------------------"

if [[ "$OSTYPE" == "darwin"* ]]; then
  #############################################################################
  # MAC OS BRANCH                                                             #
  #############################################################################
  echo "MacOS detected."

  brew="/usr/local/bin/brew"
  if [ -f "$brew" ]; then
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
  "python3"
  "exa"
  )

  for i in "${packages[@]}"
  do
    brew install $i
    echo "---------------------------------------------------------"
  done

  echo "Installing rust compiler."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Need Rust compiler
  echo "---------------------------------------------------------"


  echo "installing RCM, for dotfiles management."
  brew tap thoughtbot/formulae
  brew install rcm
  echo "---------------------------------------------------------"

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  #############################################################################
  # LINUX-GNU BRANCH                                                          #
  #############################################################################
  echo "Linux-GNU detected"

  add-apt-repository ppa:git-core/ppa
  apt-get update

  packages=(
  "git"
  "tmux"
  "neovim"
  "gnupg"
  )

  for i in "${packages[@]}"
  do
    apt-get -y install $i
    echo "---------------------------------------------------------"
  done

  found=`command -v wget`
  if [ -z "${found}" ]; then
    # Install exa
    unzip $(wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip)
    mv exa-linux-x86_64 /usr/local/bin/exa

    wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | apt-key add -

  else
    echo "wget is not installed. Installing before proceeding."
    apt-get install wget

    wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
    unzip exa-linux-x86_64-0.9.0.zip
    rm exa-linux-x86_64-0.9.0.zip
    mv exa-linux-x86_64 /usr/local/bin/exa

    wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | apt-key add -
  fi

  echo "deb https://apt.thoughtbot.com/debian/ stable main" | tee /etc/apt/sources.list.d/thoughtbot.list
  apt-get update
  apt-get -y install rcm
  echo "---------------------------------------------------------"

fi

###############################################################################
# COMMON                                                                      #
###############################################################################
echo "installing vim plug"
curl -fLo editor/config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "---------------------------------------------------------"

echo "installing pynvim"
pip3 install pynvim
echo "---------------------------------------------------------"

echo "---------------------------------------------------------"
echo "Soft linking directory to '.dotfiles'"
CWD=`pwd`
cd ..
ln -s $CWD ~/.dotfiles
cd $CWD

cp rcrc ~/.rcrc
cd $HOME

# Install the dotfiles
echo "running RCM's rcup command"
echo "This is symlink the rc files in .dofiles"
echo "with the rc files in $HOME"
echo "---------------------------------------------------------"

rcup

echo "---------------------------------------------------------"
echo "You'll need to log out for this to take effect"
echo "---------------------------------------------------------"

# Install fish bc we need a solution for the 90s
echo "Installing fish"
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install fish
  chsh -s /usr/local/bin/fish

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  apt-get -y install fish
  chsh -s /usr/local/bin/fish

fi

echo "---------------------------------------------------------"
echo "All done!"
echo "Open nvim and run :PlugInstall to activate the init.vim configuration."
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
