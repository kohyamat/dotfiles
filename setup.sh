#!/bin/bash

set -u

# Check OS
OS="$(uname)"
case "${OS}" in
    'Linux')
        DISTRO="$(lsb_release -i | cut -f2)"
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

# Install dependencies (Base tools)
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

# Install fnm (Fast Node Manager)
if ! command -v fnm &> /dev/null; then
    echo "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

# Install uv (Modern Python Toolchain)
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install Miniconda if not already installed
if ! command -v conda &> /dev/null && [ ! -d "${HOME}/miniconda3" ]; then
    echo "Installing Miniconda..."
    if [ "${OS}" == "Darwin" ]; then
        CONDA_INSTALLER="Miniconda3-latest-MacOSX-x86_64.sh"
    else
        CONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
    fi
    curl -LO "https://repo.anaconda.com/miniconda/${CONDA_INSTALLER}"
    bash "${CONDA_INSTALLER}" -b -p "${HOME}/miniconda3"
    rm "${CONDA_INSTALLER}"
fi

# Install Oh-My-Zsh & Plugins
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Zsh Plugins (p10k & autosuggestions)
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# --- Solve Symlink Conflicts ---
echo "Force cleaning up conflicting default configuration files..."
rm -rf "${HOME}/.zshrc"
rm -rf "${HOME}/.zshrc.pre-oh-my-zsh"
rm -rf "${HOME}/.p10k.zsh"
rm -rf "${HOME}/.zshenv"
rm -rf "${HOME}/.tmux.conf"
[ -L "${HOME}/.config/nvim" ] || rm -rf "${HOME}/.config/nvim"
[ -L "${HOME}/.config/ruff" ] || rm -rf "${HOME}/.config/ruff"
# Remove old pdm config if exists as a directory
[ -d "${HOME}/.config/pdm" ] && rm -rf "${HOME}/.config/pdm"

# Link configuration files using GNU Stow
echo "Creating symlinks with GNU Stow..."
stow -v -R -t "${HOME}" nvim
stow -v -R -t "${HOME}" tmux
stow -v -R -t "${HOME}" config
stow -v -R -t "${HOME}" zsh

# Initialize conda after linking
if [ -f "${HOME}/miniconda3/bin/conda" ]; then
    "${HOME}/miniconda3/bin/conda" init zsh
fi

# Tmux Plugin Manager (TPM)
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

echo "Setup completed!"
