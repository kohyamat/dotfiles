# dotfiles

Configuration files of vim, neovim, zsh, tmux, etc.


## Tips

* Build python with homebrew-installed tcl-tk via pyenv on macOS

```bash
PYTHON_CONFIGURE_OPTS="--enable-framework　--with-tcltk-includes='-I/usr/local/opt/tcl-tk/include' --with-tcltk-libs='-L/usr/local/opt/tcl-tk/lib -ltcl8.6 -ltk8.6'" pyenv install 3.8.5
```
