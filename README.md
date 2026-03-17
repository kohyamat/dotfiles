# dotfiles

neovim, zsh, tmux 等の個人的な設定

## インストール

```bash
git clone https://github.com/kohyamat/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

## インストール後にやること

1. **シェルの再起動**: `source ~/.zshrc`
2. **Node.js のインストール**: `fnm install --lts`
3. **Neovim の起動**: `nvim` (プラグインのインストール完了まで待つ)
4. **フォント設定**: 端末の設定で **Nerd Font** を選択する
