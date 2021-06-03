#!/bin/bash

if [[ -z "${LAB_DIRNAME}" ]]; then
  LAB_DIRECTORY_NAME="lab"
else
  LAB_DIRECTORY_NAME="${LAB_DIRNAME}"
fi

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
install_brew_maybe coreutils || echo "CoreUtils Installed."
install_brew_maybe glib || echo "GLIB Installed."
install_brew_maybe python3 || echo "Python 3 Installed."
install_brew_maybe python2 || echo "Python 2 Installed."
install_brew_maybe numpy || echo "Numpy Installed."

if [ "$(sw_vers -productVersion)" == "10.15" ]; then
	if [ -z "$(brew ls --versions sdl2 | grep HEAD)" ]; then
		echo "Installing HEAD version of SDL2 on OSX Catalina"
		brew unlink sdl2 || "Unliked current SDL2"
		brew install sdl2 --HEAD || "Installed HEAD SDL2"
	fi
	SDL_VERSION=$(brew ls sdl2 --versions | xargs -n1 | grep HEAD)
else
	install_brew_maybe sdl2 || echo "SDL2 Installed."
	SDL_VERSION=$(brew ls sdl2 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
fi

# Install bazel
# brew cask list homebrew/cask-versions/adoptopenjdk8 || brew cask install homebrew/cask-versions/adoptopenjdk8
# install_brew_maybe bazel
# brew outdated bazel || brew upgrade -v bazel # We need the latest bazel version

# Make sure numpy is installed in python as well as for C++ libs
python3 -m pip install --upgrade numpy

# Get versions for glib and Python3
GLIB_VERSION=$(brew ls glib --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
PYTHON_VERSION=$(brew ls python3 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 2 | rev)
# PYTHON2_VERSION=$(brew ls python2 --versions | xargs -n1 | sort | xargs | rev | cut -d' ' -f 3 | rev)

echo "Using SDL version $SDL_VERSION"
echo "Using GLIB version $GLIB_VERSION"
echo "Using Python version $PYTHON_VERSION"


# Clone the DMLab install
git clone https://github.com/DavidMChan/DMLabInstall.git || echo "Cloning DMLabInstall repository failed..."
git clone https://github.com/deepmind/lab.git $LAB_DIRECTORY_NAME || echo "Cloning failed... We're going to keep trying..."
cd $LAB_DIRECTORY_NAME && git checkout macos || ( echo "Error: Failure checking out repository" && exit 1 )

# Update the SDL and Python paths
sed -i '.bak' "s/glib\/2.62.3/glib\/$GLIB_VERSION/g" WORKSPACE
sed -i '' "s/sdl2\/2.0.10/sdl2\/$SDL_VERSION/g" WORKSPACE
sed -i '.bak' "s/3.7.4_1/$PYTHON_VERSION/g" bazel/python.BUILD
# sed -i '' "s/2.7.16_1/$PYTHON2_VERSION/g" python.BUILD

# Write the BazelRC file
echo "build -c opt --python_version=PY3 --apple_platform_type=macos --define graphics=sdl" > .bazelrc
echo "run -c opt --python_version=PY3 --apple_platform_type=macos --define graphics=sdl" >> .bazelrc

# Patch the BUILD file on catalina
if [ "$(sw_vers -productVersion)" == "10.15" ]; then
	echo "Patching BUILD on OSX Catalina"
	git apply ../DMLabInstall/catalina_BUILD.patch
fi

xcode-select --install
sudo xcodebuild -license accept
export BAZEL_VERSION=4.1.0
curl -fLO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
chmod +x "bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
./bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh --user

# Build the library
~/bin/bazel build //:deepmind_lab.so

# Copy the data from our lab version to the target lab version
rsync -avh ../DMLabInstall/lab/ .
rm -rf ../DMLabInstall

# Demonstrate that this works
~/bin/bazel run //:python_random_agent -- --length=10000 --width=640 --height=480
