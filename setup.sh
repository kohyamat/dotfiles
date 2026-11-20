#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="${HOME}/dotfiles_old/$(date +%Y%m%d_%H%M%S)"

# --- OS & Environment Detection ---
OS="$(uname -s)"
ARCH="$(uname -m)"
IS_WSL=false

if [ "${OS}" = "Linux" ]; then
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO="${ID:-linux}"
  else
    DISTRO="linux"
  fi
  if grep -qi "microsoft" /proc/version 2>/dev/null; then
    IS_WSL=true
  fi
elif [ "${OS}" = "Darwin" ]; then
  DISTRO="macOS"
else
  echo "Unsupported OS: ${OS}"
  exit 1
fi

echo "Detected OS: ${OS} (${DISTRO}), Arch: ${ARCH}, WSL2:${IS_WSL}"

# --- Backup Function ---
maybe_backup() {
  local target="$1"
  if [ -L "$target" ]; then
    echo "Removing existing symlink: $target"
    rm "$target"
    return
  fi

  if [ -e "$target" ]; then
    echo "Found existing file/directory: $target"
    read -p "Do you want to back it up to ${BACKUP_DIR}? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mkdir -p "$BACKUP_DIR"
      local relative_path="${target#$HOME/}"
      mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
      mv "$target" "$BACKUP_DIR/$relative_path"
      echo "Backed up to $BACKUP_DIR/$relative_path"
    else
      echo "Skipped $target (Note: Stow might fail if it exists)"
    fi
  fi
}

# --- System Dependencies (Multi-Distro) ---
install_linux_packages() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get update
    sudo apt-get install -y stow git tmux ripgrep fd-find bat jq python3 python3-pip python3-venv curl build-essential unzip xsel bash-completion
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y stow git tmux ripgrep fd-find bat jq python3 python3-pip curl gcc gcc-c++ make unzip xsel bash-completion
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm --needed stow git tmux ripgrep fd bat jq python python-pip curl base-devel unzip xsel bash-completion
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y stow git tmux ripgrep fd bat jq python3 python3-pip curl gcc gcc-c++ make unzip xsel bash-completion
  else
    echo "Warning: Supported package manager not found. Please install dependencies manually."
  fi

  mkdir -p "${HOME}/.local/bin"

  # Debian/Ubuntu 等でコマンド名が fdfind になる場合のシンボリックリンク対応
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
  fi

  # Debian/Ubuntu 等でコマンド名が batcat になる場合のシンボリックリンク対応
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    ln -sf "$(command -v batcat)" "${HOME}/.local/bin/bat"
  fi
}

if [ "${OS}" = "Darwin" ]; then
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  # すでにインストール済みのパッケージを勝手にアップグレードして止まるのを防ぐため、未導入のものだけ入れる
  BREW_PACKAGES=(stow git neovim tmux ripgrep fd fzf bat jq bash bash-completion@2 lazygit)
  MISSING_PACKAGES=()
  for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula "$pkg" &>/dev/null; then
      MISSING_PACKAGES+=("$pkg")
    fi
  done

  if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo "Installing missing Homebrew packages: ${MISSING_PACKAGES[*]}"
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "${MISSING_PACKAGES[@]}" || true
  else
    echo "All Homebrew packages are already installed."
  fi
elif [ "${OS}" = "Linux" ]; then
  install_linux_packages
fi

# インストールチェックのために一時的にPATHを通す
mkdir -p "${HOME}/.local/bin"
export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${HOME}/.local/share/fnm:${PATH}"

# --- fzf (Linuxではディストロ標準が古く `fzf --bash` が使えないためGitから導入) ---
if ! command -v fzf &>/dev/null; then
  echo "Installing fzf..."
  if [ ! -d "${HOME}/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  fi
  "${HOME}/.fzf/install" --bin
  ln -sf "${HOME}/.fzf/bin/fzf" "${HOME}/.local/bin/fzf"
fi

# --- Neovim (Linuxではディストロ標準が古いため公式最新バイナリを配置) ---
if ! command -v nvim &>/dev/null; then
  echo "Installing latest Neovim..."
  if [ "${ARCH}" = "x86_64" ]; then
    NVIM_ARCH="x86_64"
  elif [ "${ARCH}" = "aarch64" ] \vert{}\vert{} [ "${ARCH}" = "arm64" ]; then
    NVIM_ARCH="arm64"
  else
    echo "Unsupported architecture for Neovim binary: ${ARCH}. Please install Neovim manually."
    NVIM_ARCH=""
  fi

  if [ -n "${NVIM_ARCH}" ]; then
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
    rm -rf "${HOME}/.local/nvim"
    mkdir -p "${HOME}/.local/nvim"
    tar -C "${HOME}/.local/nvim" --strip-components=1 -xzf "nvim-linux-${NVIM_ARCH}.tar.gz"
    ln -sf "${HOME}/.local/nvim/bin/nvim" "${HOME}/.local/bin/nvim"
    rm "nvim-linux-${NVIM_ARCH}.tar.gz"
  fi
fi

# --- fnm (Node.js) ---
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "${HOME}/.local/share/fnm" --skip-shell
fi

eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
fnm use lts-latest

# corepack の有効化
echo "Enabling corepack for yarn and pnpm..."
if ! command -v corepack &>/dev/null; then
  npm install -g corepack
fi
corepack enable

if ! command -v tree-sitter &>/dev/null; then
  echo "Installing tree-sitter-cli..."
  npm install -g tree-sitter-cli
fi

# --- rustup (Rust) ---
if ! command -v rustup &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
# shellcheck disable=SC1091
source "${HOME}/.cargo/env" 2>/dev/null || true
rustup update stable
rustup default stable

# --- uv (Python Package Manager) ---
if ! command -v uv &>/dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# --- zoxide (Better cd) ---
if ! command -v zoxide &>/dev/null; then
  echo "Installing zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# --- lazygit (Linux用: 最新バイナリをGitHub releasesから取得) ---
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  if [ "${OS}" = "Linux" ]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    if [ "${ARCH}" = "x86_64" ]; then
      LG_ARCH="x86_64"
    elif [ "${ARCH}" = "aarch64" ] \vert{}\vert{} [ "${ARCH}" = "arm64" ]; then
      LG_ARCH="arm64"
    else
      echo "Unsupported architecture for lazygit: ${ARCH}"
      LG_ARCH=""
    fi

    if [ -n "${LG_ARCH}" ]; then
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"
      tar xf lazygit.tar.gz lazygit
      install -m 755 lazygit "${HOME}/.local/bin/lazygit"
      rm -f lazygit lazygit.tar.gz
    fi
  fi
fi

# --- Miniforge3 (Data Science / Bioinformatics) ---
if ! command -v conda &>/dev/null && [ ! -d "${HOME}/miniforge3" ]; then
  echo "Installing Miniforge3..."
  if [ "${OS}" = "Darwin" ]; then
    FORGE_INSTALLER="Miniforge3-MacOSX-${ARCH}.sh"
  else
    FORGE_INSTALLER="Miniforge3-Linux-${ARCH}.sh"
  fi
  curl -LO "https://github.com/conda-forge/miniforge/releases/latest/download/${FORGE_INSTALLER}"
  bash "${FORGE_INSTALLER}" -b -p "${HOME}/miniforge3"
  rm "${FORGE_INSTALLER}"

  echo "Configuring Conda channels for Bioinformatics (Bioconda)..."
  "${HOME}/miniforge3/bin/conda" config --add channels defaults
  "${HOME}/miniforge3/bin/conda" config --add channels bioconda
  "${HOME}/miniforge3/bin/conda" config --add channels conda-forge
  "${HOME}/miniforge3/bin/conda" config --set channel_priority strict

  echo "Configuring Conda package cache directory..."
  "${HOME}/miniforge3/bin/conda" config --add pkgs_dirs "${HOME}/.cache/conda_pkgs"

  echo "Disabling auto-activation of conda base environment..."
  "${HOME}/miniforge3/bin/conda" config --set auto_activate_base false
fi

# --- Prepare & Stow ---
echo "Checking for existing files to backup..."
maybe_backup "${HOME}/.bash_custom"
maybe_backup "${HOME}/.inputrc"
maybe_backup "${HOME}/.tmux.conf"

mkdir -p "${HOME}/.config"
for config_path in "${DOTFILES_DIR}/config/.config/"*; do
  config_name=$(basename "$config_path")
  maybe_backup "${HOME}/.config/$config_name"
done
maybe_backup "${HOME}/.config/nvim"

echo "Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"
PACKAGES=("nvim" "tmux" "config" "bash")

for pkg in "${PACKAGES[@]}"; do
  stow -D -t "$HOME" "$pkg" 2>/dev/null || true
  stow -v -t "$HOME" "$pkg"
done

# --- Safe .bashrc & .bash_profile Update ---
BASHRC="${HOME}/.bashrc"
touch "$BASHRC"

if ! grep -q "source ~/.bash_custom" "$BASHRC"; then
  {
    echo ""
    echo "# Load custom dotfiles configuration"
    echo "if [ -f ~/.bash_custom ]; then"
    echo "    source ~/.bash_custom"
    echo "fi"
  } >>"$BASHRC"
  echo "Added ~/.bash_custom sourcing to ~/.bashrc"
fi

# Miniforgeの初期化処理を.bashrcに書き込み (.bash_customの後に配置されるようここで実行)
if [ -f "${HOME}/miniforge3/bin/conda" ] && ! grep -q "conda initialize" "$BASHRC"; then
  "${HOME}/miniforge3/bin/conda" init bash
fi

# macOS向けのログインシェル設定 (.bash_profileの生成とHomebrew版Bashへの切り替え)
if [ "${OS}" = "Darwin" ]; then
  BASH_PROFILE="${HOME}/.bash_profile"
  touch "$BASH_PROFILE"
  if ! grep -q "\.bashrc" "$BASH_PROFILE"; then
    {
      echo ""
      echo "# Load .bashrc for login shells (macOS Terminal default)"
      echo "if [ -f ~/.bashrc ]; then"
      echo "    source ~/.bashrc"
      echo "fi"
    } >>"$BASH_PROFILE"
    echo "Added ~/.bash_custom sourcing to ~/.bash_profile"
  fi

  BREW_BASH="$(brew --prefix)/bin/bash"
  if [ -x "$BREW_BASH" ]; then
    if ! grep -q "$BREW_BASH" /etc/shells; then
      echo "Adding $BREW_BASH to /etc/shells (requires sudo)..."
      echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
    fi
    if [ "$SHELL" != "$BREW_BASH" ]; then
      echo "Changing default login shell to Homebrew Bash..."
      chsh -s "$BREW_BASH"
    fi
  fi
fi

# --- Tmux Plugin Manager ---
if ! [ -d "${HOME}/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi
"${HOME}/.tmux/plugins/tpm/bin/install_plugins" || true

echo ""
echo "====================================================================="
echo "Setup completed successfully!"
echo "Please restart your terminal or run: source ~/.bashrc"
echo "(Optional) For desktop GUI environments, run 'stow -v -t ~ alacritty' if needed."
echo "====================================================================="
