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

# Install Miniconda if not already installed
if ! command -v conda &> /dev/null; then
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

# Install PDM if not already installed
if ! command -v pdm &> /dev/null; then
    echo "Installing PDM..."
    curl -sSL https://pdm-project.org/install-pdm.py | python3 -
fi

# Install Oh-My-Zsh if not already installed
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Solve Symlink Conflicts ---
echo "Force cleaning up conflicting default configuration files..."
# 強力に削除（ディレクトリの場合も考慮して -rf）
rm -rf "${HOME}/.zshrc"
rm -rf "${HOME}/.zshrc.pre-oh-my-zsh"
rm -rf "${HOME}/.p10k.zsh"
rm -rf "${HOME}/.zshenv"
rm -rf "${HOME}/.tmux.conf"
[ -L "${HOME}/.config/nvim" ] || rm -rf "${HOME}/.config/nvim"
[ -L "${HOME}/.config/pdm" ] || rm -rf "${HOME}/.config/pdm"
[ -L "${HOME}/.config/ruff" ] || rm -rf "${HOME}/.config/ruff"

# Link configuration files using GNU Stow
echo "Creating symlinks with GNU Stow..."
# カレントディレクトリから実行
stow -v -R -t "${HOME}" nvim
stow -v -R -t "${HOME}" tmux
stow -v -R -t "${HOME}" config
stow -v -R -t "${HOME}" zsh

# Initialize conda after linking (so it writes to our repo-managed .zshrc)
if [ -f "${HOME}/miniconda3/bin/conda" ]; then
    echo "Initializing Conda..."
    "${HOME}/miniconda3/bin/conda" init zsh
fi

# Tmux Plugin Manager (TPM) setup
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

# Install/Update Tmux plugins from CLI
echo "Installing Tmux plugins..."
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

echo "Setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.zshrc'"
