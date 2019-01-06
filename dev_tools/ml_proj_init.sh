#!/bin/bash

# Sets up the folder structure and relevant build files in order to build AI based projects.
# Results in full project directory with required docker, make, and python files populated in a git repo

# Create folder structure
echo "---------------------------------------------------------"
echo "Creating project folder structure"
echo "---------------------------------------------------------"

folders=(
  "data"
  "data/raw"
  "data/processed"
  "src"
  "src/data"
  "src/model"
  "logs"
  "models"
)

for i in "${folders[@]}"
do
  mkdir ./$i
  echo "$i created"
done

# Touch init.py files in src and requirements.txt
inits=(
  "src/__init__.py"
  "src/data/__init__.py"
  "src/model/__init__.py"
  "requirements.txt"
)

for i in "${inits[@]}"
do
  touch ./$i
  echo "$i created"
done

echo "---------------------------------------------------------"
echo "Done"
echo "---------------------------------------------------------"


echo "---------------------------------------------------------"
echo "Creating project build files"
echo "---------------------------------------------------------"

# Touch build files
build_files=(
  "Dockerfile"
  "Makefile"
)

for i in "${build_files[@]}"
do
  cp /Users/juliantrue/.dotfiles/dev_tools/templates/$i ./$i
done

echo "---------------------------------------------------------"
echo "Project build files generated"
echo "---------------------------------------------------------"

echo "Done, nothing left to do"

