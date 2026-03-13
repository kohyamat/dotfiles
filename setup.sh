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
    curl -O "https://repo.anaconda.com/miniconda/${CONDA_INSTALLER}"
    bash "${CONDA_INSTALLER}" -b -p "${HOME}/miniconda3"
    rm "${CONDA_INSTALLER}"
    # Initialize conda (this adds the block to .zshrc)
    "${HOME}/miniconda3/bin/conda" init zsh
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

# Link configuration files using GNU Stow
echo "Creating symlinks with GNU Stow..."
stow -v -t "${HOME}" nvim
stow -v -t "${HOME}" tmux
stow -v -t "${HOME}" config
stow -v -t "${HOME}" zsh

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

echo "Setup completed successfully!"
