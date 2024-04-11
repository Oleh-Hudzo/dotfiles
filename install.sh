#!/bin/bash

# Stop on error
set -e
REPO_ROOT="$(git rev-parse --show-toplevel)"
echo "REPO_ROOT is set to: $REPO_ROOT"

# Install dependencies on MacOS
install_macos() {
  echo "Detected MacOS"
  # Check if Homebrew is installed
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "Installing powerlevek10k..."
  brew install powerlevel10k
  echo "Installing Neovim..."
  brew install neovim
}

# Install dependencies Linux
install_linux() {
  echo "Detected Linux"
  echo "Installing powerlevek10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  if command -v apt &> /dev/null; then
    echo "Using apt package manager to install dependencies..."
    sudo apt update && sudo apt install -y neovim
  elif command -v yum &> /dev/null; then
    echo "Using yum package manager to install dependencies..."
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    yum install -y neovim python3-neovim
  elif command -v dnf &> /dev/null; then
    echo "Using dnf package manager to install dependencies..."
    dnf install -y neovim python3-neovim
  elif command -v pacman &> /dev/null; then
    echo "Using pacman package manager to install dependencies..."
    pacman -S neovim
  else
    echo "Could not find a package manager to install dependencies. Please install manually."
  fi
}

OS="$(uname)"
case $OS in
  "Darwin")
    install_macos
    ;;
  "Linux")
    install_linux
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Dependencies installed!"
echo "Creating symlinks..."

# Creating a symlink and backing up the original file if it exists
create_symlink() {
  local target="$1"
  local link_name="$2"

  # Check if the target link name exists or is a symlink
  if [ -e "$link_name" ] || [ -L "$link_name" ]; then
    local timestamp=$(date +"%Y%m%d")
    local backup_name="${link_name}.backup.${timestamp}"
    echo "$link_name exists, backing up to $backup_name"
    mv "$link_name" "$backup_name"
  fi

  ln -sfn "$target" "$link_name"
  echo "Created symlink for $target at $link_name"
}

create_symlink "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
create_symlink "$REPO_ROOT/nvim" "$HOME/.config/nvim"
rm -f "$HOME/.config/nvim/nvim"

echo "Done!"
echo "Please restart your shell to apply changes"

