#!/bin/bash

set -e 

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

# Install system deps
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get update && sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get -y install \
  build-essential \
  git \
  fish \
  python3 \
  python3-dev \
  tmux \
  wget 

# Install exa if not installed already
if [ -z "$(which exa)" ]; then
  echo "Installing Exa."
  unzip $(wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip)
  rm exa-linux-x86_64-0.9.0.zip
  mv exa-linux-x86_64 /usr/local/bin/exa
else
  echo "Exa installation found at: $(which exa). Passing."
fi

# Add the thoughtbot ppa and install rcm 
if [ -z "$(which rcup)" ]; then
  echo "Installing rcm."
  wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | apt-key add -
  sudo apt-get update
  sudo apt-get -y install rcm
else
  echo "Rcm installation found at: $(which rcup). Passing."
fi

# Change shell to fish
if [ "$SHELL" == "/usr/local/bin/fish" ]; then
  echo "Shell is already fish. Passing."
else
  echo "Changing shell to fish."
  chsh -s /usr/local/bin/fish
fi

# Install rustup if not present
if [ -z "$(which rustup)" ]; then
  echo "Installing rust toolchain"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "Rust found on this system. Passing."
fi

# Install Nodejs if not already installed
if [ -z "$(which node)" ]; then
  echo "Installing Node Js."
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "Node Js found on this system. Passing."
fi

# Install the necessary deps for neovim
python3 -m pip install pynvim

# Symlink rcrc file and get the settings in place
ln -s rcrc ~/.rcrc
rcup
