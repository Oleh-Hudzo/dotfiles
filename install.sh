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
  # Ensure oh-my-zsh is installed
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
  # Ensure starship is installed
  if ! command -v starship &> /dev/null; then
    echo "starship not found. Installing..."
    brew install starship
  fi
  # Ensure neovim is installed
  if ! command -v nvim &> /dev/null; then
    echo "neovim not found. Installing..."
    brew install neovim
  fi
  brew install neovim
}

# Install dependencies Linux
install_linux() {
  # Install dependencies
  echo "Detected Linux"
  # Check if Debian/Ubuntu/Kali
  if command -v apt-get &> /dev/null; then
    echo "Detected Debian/Ubuntu/Kali"
    sudo apt-get update
    sudo apt-get install -y curl git zsh npm unzip
  fi
  # Check if Fedora/RedHat/CentOS
  if command -v dnf &> /dev/null; then
    echo "Detected Fedora/RedHat/CentOS"
    sudo dnf install -y curl git zsh npm unzip
  fi
  # Check if Arch/Manjaro
  if command -v pacman &> /dev/null; then
    echo "Detected Arch/Manjaro"
    sudo pacman -Syu
    sudo pacman -S --noconfirm curl git zsh npm unzip
  fi
  # Check if openSUSE
  if command -v zypper &> /dev/null; then
    echo "Detected openSUSE"
    sudo zypper refresh
    sudo zypper install -y curl git zsh npm unzip
  fi

  # Install go
  if ! command -v go &> /dev/null; then
    echo "Installing go..."
    curl -LO https://golang.org/dl/go1.22.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
    rm go1.22.2.linux-amd64.tar.gz
    echo "go installed."
  else
    echo "go already installed. Skipping..."
  fi

  # Check if neovim is installed
  if command -v nvim &> /dev/null; then
    # Extracting Neovim version
    NVIM_VERSION=$(nvim --version | head -n 1 | cut -d ' ' -f 2 | sed 's/v//')
    # Comparing Neovim version, assuming required version is 0.8.0
    REQUIRED_VERSION="0.8.0"
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NVIM_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
      echo "Neovim version is less than $REQUIRED_VERSION, upgrading..."
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
      chmod u+x nvim.appimage
      ./nvim.appimage
      sudo mv nvim.appimage /usr/local/bin/nvim
      echo "Neovim version is $(nvim --version | head -n 1 | cut -d ' ' -f 2 | sed 's/v//')"
      echo "Neovim upgraded."
    else
      echo "Neovim $NVIM_VERSION already installed. Skipping..."
    fi
  else
    echo "Neovim not installed. Installing..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
    echo "Neovim version is $(nvim --version | head -n 1 | cut -d ' ' -f 2 | sed 's/v//')"
    echo "Neovim installed."
  fi

  # Check if oh-my-zsh is installed
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh already installed. Skipping..."
  fi
  # Check if starship is installed
  if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh
  else
    echo "starship already installed. Skipping..."
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
create_symlink "$REPO_ROOT/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$REPO_ROOT/wezterm" "$HOME/.config/wezterm"
rm -f "$HOME/.config/nvim/nvim"

echo "Done!"
echo "Please restart your shell to apply changes"
