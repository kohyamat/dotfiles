#!/bin/bash

set -u

# Get absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="${HOME}/dotfiles_old/$(date +%Y%m%d_%H%M%S)"

# Check OS
OS="$(uname)"
case "${OS}" in
    'Linux')
        DISTRO="$(lsb_release -i | cut -f2 2>/dev/null || echo "Linux")"
        ;;
    'Darwin')
        DISTRO='macOS'
        ;;
    *)
        echo "Unknown OS: ${OS}"
        exit 1
        ;;
esac

echo "Detected OS: ${OS} (${DISTRO})"

# Function to handle existing items:
# - If it's a symlink, remove it.
# - If it's a real file/directory, ask to backup.
maybe_backup() {
    local target="$1"
    
    # If it's a symlink, just remove it to let Stow handle it
    if [ -L "$target" ]; then
        echo "Removing existing symlink: $target"
        rm "$target"
        return
    fi

    # If it's a real file or directory
    if [ -e "$target" ]; then
        echo "Found existing file/directory: $target"
        read -p "Do you want to back it up to ${BACKUP_DIR}? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$BACKUP_DIR"
            # Maintain directory structure in backup
            local relative_path="${target#$HOME/}"
            mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
            mv "$target" "$BACKUP_DIR/$relative_path"
            echo "Backed up to $BACKUP_DIR/$relative_path"
        else
            echo "Skipped $target (Note: Stow might fail if it exists)"
        fi
    fi
}

# Install dependencies
if [ "${OS}" == "Darwin" ]; then
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew update
    brew install stow git neovim tmux ripgrep fzf python3 r zsh curl
elif [ "${OS}" == "Linux" ]; then
    sudo apt update
    sudo apt install -y stow git neovim tmux ripgrep fzf python3 python3-pip zsh curl
fi

# Install fnm, uv, Miniconda, Oh-My-Zsh (Previously defined logic...)
if ! command -v fnm &> /dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
if ! command -v conda &> /dev/null && [ ! -d "${HOME}/miniconda3" ]; then
    if [ "${OS}" == "Darwin" ]; then
        CONDA_INSTALLER="Miniconda3-latest-MacOSX-x86_64.sh"
    else
        CONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
    fi
    curl -LO "https://repo.anaconda.com/miniconda/${CONDA_INSTALLER}"
    bash "${CONDA_INSTALLER}" -b -p "${HOME}/miniconda3"
    rm "${CONDA_INSTALLER}"
fi
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Zsh Plugins (p10k & autosuggestions)
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# --- Check and Backup existing files before Stow ---
echo "Checking for existing files to backup..."
maybe_backup "${HOME}/.zshrc"
maybe_backup "${HOME}/.zshenv"
maybe_backup "${HOME}/.p10k.zsh"
maybe_backup "${HOME}/.tmux.conf"

# Automatically check for managed configs in .config
for config_path in "${DOTFILES_DIR}/config/.config/"*; do
    config_name=$(basename "$config_path")
    maybe_backup "${HOME}/.config/$config_name"
done
# Specialized check for nvim
maybe_backup "${HOME}/.config/nvim"

# --- Execute Stow ---
echo "Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"

# Run stow for each package
for pkg in nvim tmux config zsh; do
    echo "Stowing $pkg..."
    # Always try to unstow first to clean up existing links
    stow -D -t "$HOME" "$pkg" 2>/dev/null
    stow -v -t "$HOME" "$pkg"
done

# Initialize conda after linking
if [ -f "${HOME}/miniconda3/bin/conda" ]; then
    "${HOME}/miniconda3/bin/conda" init zsh
fi

# Tmux Plugin Manager
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

echo "Setup completed!"
