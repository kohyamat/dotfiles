# dotfiles

neovim, zsh, tmux 等の個人的な設定

## 🛠 主要ツール構成
- **Python**: [uv](https://github.com/astral-sh/uv) (高速なパッケージ・バージョン管理)
- **Node.js**: [fnm](https://github.com/voronianski/fnm) (Rust製の高速なバージョン管理)
- **Editor**: Neovim (Lazy.nvim, Blink.cmp, Ruff)
- **Terminal**: Tmux (Catppuccin theme)
- **Shell**: Zsh (Oh-My-Zsh, Powerlevel10k)

## 📦 事前に必要な依存関係
インストール前に以下のツールがシステムに導入されていることを確認してください。
- **Rust**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **Build Tools**: `gcc`, `make`, `pkg-config`, `libssl-dev` (Linuxの場合)
- **Others**: `curl`, `git`, `stow`

## 🚀 インストール

```bash
git clone https://github.com/kohyamat/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

## ✅ インストール後にやること

1. **シェルの再起動**: `source ~/.zshrc`
2. **Node.js のインストール**: `fnm install --lts`
3. **Python の確認**: `uv --version` (仮想環境作成は `uv venv`)
4. **Neovim の起動**: `nvim` (プラグインの自動インストールを待つ)
5. **フォント設定**: 端末の設定で **Nerd Font** を選択する
