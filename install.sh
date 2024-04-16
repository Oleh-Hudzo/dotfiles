#!/bin/bash

# Stop on error
set -e
REPO_ROOT="$(git rev-parse --show-toplevel)"
echo "REPO_ROOT is set to: $REPO_ROOT"

# Function to install packages on MacOS
install_macos() {
  echo "Detected MacOS"
  # Check if Homebrew is installed
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Ensure required packages are installed using Homebrew
  brew_packages=("starship" "neovim" "tmux" "joshmedeski/sesh/sesh" "zoxide" "fzf")
  for pkg in "${brew_packages[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
      echo "$pkg not found. Installing..."
      brew install "$pkg"
    fi
  done
}

# Function to install packages on Linux
install_linux() {
  echo "Detected Linux"
  # Define package manager commands
  package_managers=(
    "sudo apt-get install -y curl git zsh npm unzip tmux "  # Debian/Ubuntu/Kali
    "sudo dnf install -y curl git zsh npm unzip tmux"      # Fedora/RedHat/CentOS
    "sudo pacman -S --noconfirm curl git zsh npm unzip tmux"  # Arch/Manjaro
    "sudo zypper install -y curl git zsh npm unzip tmux"   # openSUSE
  )
  # Loop through package managers and execute the first available one
  for pkg_manager_cmd in "${package_managers[@]}"; do
    if command -v ${pkg_manager_cmd%% *} &> /dev/null; then
      echo "Installing dependencies using: $pkg_manager_cmd"
      eval "$pkg_manager_cmd"
      break
    fi
  done

  # Install go if not already installed
  if ! command -v go &> /dev/null; then
    echo "Installing go..."
    curl -LO https://golang.org/dl/go1.22.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
    rm go1.22.2.linux-amd64.tar.gz
    echo "go installed."
  else
    echo "go already installed. Skipping..."
  fi

  # Install Neovim
  if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
  fi

  # Install sesh
  if ! command -v sesh &> /dev/null; then
    echo "Installing sesh..."
    go install github.com/joshmedeski/sesh@latest
  fi

  # Install zoxide
  if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi

  # Install fzf
  if ! command -v fzf &> /dev/null; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
  fi
}

# Function to install oh-my-zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh already installed. Skipping..."
  fi
}

# Function to install starship
install_starship() {
  if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh
  else
    echo "starship already installed. Skipping..."
  fi
}

# Function to install tmux
install_tmux_plugins() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    echo "tmux plugions already installed. Skipping..."
  fi
}

# Determine OS and install dependencies accordingly
OS="$(uname)"
case $OS in
  "Darwin")
    install_macos
    install_oh_my_zsh
    install_starship
    install_tmux_plugins
    ;;
  "Linux")
    install_linux
    install_oh_my_zsh
    install_starship
    install_tmux_plugins
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Install oh-my-zsh and starship
install_oh_my_zsh
install_starship

echo "Dependencies installed!"
echo "Creating symlinks..."

# Function to create symlink with backup
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

# Create symlinks
create_symlink "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
create_symlink "$REPO_ROOT/nvim" "$HOME/.config/nvim"
create_symlink "$REPO_ROOT/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$REPO_ROOT/wezterm" "$HOME/.config/wezterm"
rm -f "$REPO_ROOT/wezterm/wezterm"
# Copy to clipboard functionality on Windows WSL2
create_symlink "$REPO_ROOT/xsel" "$HOME/bin/xsel"
rm -f "$HOME/.config/nvim/nvim"
create_symlink "$REPO_ROOT/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$REPO_ROOT/.tmux" "$HOME/.tmux"
create_symlink "$REPO_ROOT/tmux-sesh-selector.sh" "$HOME/tmux-sesh-selector.sh"

echo "Done!"
echo "Please restart your shell to apply changes"

