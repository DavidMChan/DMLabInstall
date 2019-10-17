#!/bin/bash

set -e

function install_homebrew {
    echo "Homebrew not found. Installing..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}
function install_brew_maybe {
    ( brew ls $1 --versions > /dev/null && echo "$1 already installed. Skipping..." ) ||
    ( echo "Package $1 not found. Installing..." && brew install -v $1 )
}

echo "Installing DeepMind Lab"

# Main installation

# Check for Homebrew
echo "Checking if homebrew is installed..."
brew --version > /dev/null || install_homebrew

# Check for brew packages
install_brew_maybe glib
install_brew_maybe sdl2
install_brew_maybe python3
install_brew_maybe python2
install_brew_maybe numpy

# Install bazel
brew cask list homebrew/cask-versions/adoptopenjdk8 || brew cask install homebrew/cask-versions/adoptopenjdk8
install_brew_maybe bazel
brew outdated bazel || brew upgrade -v bazel # We need the latest bazel version

# Make sure numpy is installed in python as well as for C++ libs
python3 -m pip install --upgrade numpy

# Get versions for SDL and Python3
GLIB_VERSION=$(brew ls glib --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
SDL_VERSION=$(brew ls sdl2 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
PYTHON_VERSION=$(brew ls python3 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
# PYTHON2_VERSION=$(brew ls python2 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 3 | rev)

# Clone the DMLab install
git clone https://github.com/DavidMChan/DMLabInstall.git || echo "Cloning DMLabInstall repository failed..."
git clone https://github.com/deepmind/lab.git || echo "Cloning failed... We're going to keep trying..."
cd lab && git checkout 5602604ae85d39950d43274a6bbfaff55b8d7314 || ( echo "Error: Failure checking out repository" && exit 1 )

# Copy the data from our lab version to the target lab version
rsync -avh ../DMLabInstall/lab/ .

# Update the SDL and Python paths
sed -i '.bak' "s/glib\/2.62.1/glib\/$GLIB_VERSION/g" WORKSPACE
sed -i '' "s/sdl2\/2.0.10/sdl2\/$SDL_VERSION/g" WORKSPACE
sed -i '.bak' "s/3.7.4_1/$PYTHON_VERSION/g" python.BUILD
# sed -i '' "s/2.7.16_1/$PYTHON2_VERSION/g" python.BUILD

# Write the BazelRC file
echo "build -c opt --python_version=PY3 --apple_platform_type=macos --define graphics=sdl" > .bazelrc
echo "run -c opt --python_version=PY3 --apple_platform_type=macos --define graphics=sdl" >> .bazelrc

# Build the library
bazel build //:deepmind_lab.so
bazel run //:python_random_agent -- --length=10000 --width=640 --height=480
