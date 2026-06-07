#!/usr/bin/env bash
# ------------------------------------------------------------
# Config Installer Script
# Detects OS and architecture, installs dependencies,
# and copies config files into the user's home directory.
# ------------------------------------------------------------

set -e  # Exit immediately if a command exits with a non-zero status

# Define source directory (where your config files live)
CONFIG_DIR="$HOME/config-files"

# List of config files to copy
FILES=(".zshrc" ".tmux.conf" ".p10k.zsh")

DATE="$(date +%s)"

# Detect OS type
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS: $OS"
echo "Detected Architecture: $ARCH"

# Install dependencies based on OS
if [[ "$OS" == "Linux" ]]; then
    echo "Installing dependencies using apt..."
    sudo apt update
    sudo apt install -y zsh tmux git curl fzf fd-find bat ripgrep
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    # Add Powerlevel10k if needed
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
    rm -rf $HOME/powerlevel10k
    mv powerlevel10k/ $HOME/

elif [[ "$OS" == "Darwin" ]]; then
    echo "Installing dependencies using Homebrew..."
    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update
    brew install zsh tmux git fzf fd bat ripgrep lazygit powerlevel10k


    # Handle Apple Silicon vs Intel differences if needed
    if [[ "$ARCH" == "arm64" ]]; then
        echo "Running on Apple Silicon (M1/M2/M3)..."
        # Example: adjust Homebrew path if necessary
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Running on Intel Mac..."
        eval "$(/usr/local/bin/brew shellenv)"
    fi

else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Copy config files into home directory
echo "Copying config files into home directory..."
for file in "${FILES[@]}"; do
    if [[ -f "$CONFIG_DIR/$file" ]]; then
        echo "Checking if file $file exists"
        if [[ -f "$HOME/$file" ]]; then
            echo "$file exists."
            echo "Checking if $HOME/config-backup/ exists"
            if [[ ! -d "$HOME/config-backup" ]]; then
                echo "$HOME/config-backup/ does not exists"
                echo "Creating $HOME/config-backup/ directory"
                mkdir -p "$HOME/config-backup/"
                echo "$HOME/config-backup/ created successfully"
            fi
            echo "Moving existing $file to $HOME/config-backup/"
            mv "$HOME/$file" "$HOME/config-backup/$file.bak.$DATE"
            echo "Copying $CONFIG_DIR/$file to $HOME/$file"
            cp "$CONFIG_DIR/$file" "$HOME/$file"
            echo "Copied $file to $HOME/$file"
        fi
    else
        echo "Warning: $CONFIG_DIR/$file not found, skipping..."
    fi
done

echo "✅ Setup complete! Restart your shell or tmux to apply changes."
# mv .zshrc .zshrc.bak.$DATE
