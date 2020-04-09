# Language environment
# --------------------------------------------------
case "${OSTYPE}" in
    freebsd*|darwin*)
        export LANG=en_US.UTF-8
        ;;
    linux*)
        export LANG=en_US.UTF8
        ;;
esac

# PATH
# --------------------------------------------------
PATH="/usr/bin:/usr/sbin:/bin:/sbin"
MANPATH="/usr/share/man"
if test -d /opt/X11; then
    PATH=/opt/X11/bin:$PATH
    MANPATH=/opt/X11/share/man:$MANPATH
else
    PATH=/usr/X11/bin:$PATH
    MANPATH=/usr/X11/share/man:$MANPATH
fi
test -d /usr/local && PATH=/usr/local/bin:/usr/local/sbin:$PATH &&
                      MANPATH=/usr/local/share/man:$MANPATH
test -d /opt/local && PATH=/opt/local/bin:/opt/local/sbin:$PATH &&
                      MANPATH=/opt/local/share/man:$MANPATH
test -d ${HOME}/local && PATH=${HOME}/local/bin:${HOME}/local/texbin:$PATH &&
                      MANPATH=${HOME}/local/share/man:$MANPATH
                      LD_LIBRARY_PATH=${HOME}/local/lib:$LD_LIBRARY_PATH
export PATH MANPATH LD_LIBRARY_PATH

export EDITOR=vi
export BLOCKSIZE=k

# Alias
# --------------------------------------------------
setopt complete_aliases

case "${OSTYPE}" in
    freebsd*|darwin*)
        if type gls >/dev/null 2>&1; then
            alias ls="gls --color"
        else
            alias ls="/bin/ls -G"
        fi
        ;;
    linux*)
        alias ls="ls --color"
        ;;
esac

if [[ ${OSTYPE} == darwin* ]]; then
    alias ql='qlmanage -p "$@" >& /dev/null'
    alias pv='open -a preview "$@" >& /dev/null'
fi

if type ipython >/dev/null 2>&1; then alias qipython='ipython qtconsole'; fi

# Configurations
# --------------------------------------------------
setopt COMBINING_CHARS
setopt ALWAYS_TO_END
setopt AUTO_CD
setopt AUTO_LIST
setopt AUTO_PUSHD
setopt AUTO_RESUME
setopt NO_BEEP
setopt BANG_HIST
setopt NO_CLOBBER
setopt COMPLETE_IN_WORD
setopt CORRECT
setopt CORRECT_ALL
setopt EQUALS
setopt EXTENDED_HISTORY
setopt NO_FLOW_CONTROL
setopt FUNCTION_ARGZERO
setopt GLOB_DOTS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt NO_HUP
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt NO_LIST_BEEP
setopt LIST_PACKED
setopt LIST_TYPES
setopt LONG_LIST_JOBS
setopt AUTO_MENU
setopt MAGIC_EQUAL_SUBST
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PRINT_EIGHT_BIT
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
#setopt MARK_DIRS
setopt AUTO_PARAM_KEYS
setopt NONOMATCH

# Key mappings
# --------------------------------------------------
# emacs like keybind
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
bindkey "\e[Z" reverse-menu-complete

# Command history
# --------------------------------------------------
HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history

# Completion
# --------------------------------------------------
fpath=(${HOME}/.zsh/plugins/zsh-completions/src $fpath)

# Set LS_COLORS
if type gdircolors >/dev/null 2>&1; then eval $(gdircolors ${HOME}/.zsh/dircolors/dircolors-solarized/dircolors.ansi-dark); fi
if type dircolors >/dev/null 2>&1; then eval $(dircolors ${HOME}/.zsh/dircolors/dircolors-solarized/dircolors.ansi-dark); fi
if [ -n "$LS_COLORS" ]; then zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}; fi

setopt auto_param_slash rec_exact
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' completer _oldlist _complete _expand _match _ignored _prefix _list # _history _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' format  $'- %d -'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' list-separator '--> '
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' group-name ''

autoload -U compinit
compinit -u

# Prompt
# --------------------------------------------------
if [ -e /usr/share/terminfo/*/xterm+256color ]; then
    export TERM='xterm-256color'
fi
#export TERM='xterm-color'
autoload -Uz colors && colors

# Set the prompt
fpath+=$HOME/.zsh/plugins/pure
autoload -U promptinit; promptinit
prompt pure

# # Git info
# # https://gist.github.com/scelis/244215/download#
# # Autoload zsh functions
# fpath=($HOME/.zsh/functions $fpath)
# autoload -U $HOME/.zsh/functions/*(:t)
# # Enable auto-execution of functions
# typeset -ga preexec_functions
# typeset -ga precmd_functions
# typeset -ga chpwd_functions
# # Append git functions needed for prompt
# preexec_functions+='preexec_update_git_vars'
# precmd_functions+='precmd_update_git_vars'
# chpwd_functions+='chpwd_update_git_vars'

# tmux
# --------------------------------------------------
PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# z
# -------------------------
source "${HOME}/.zsh/plugins/z/z.sh"
function precmd () {
_z --add "$(pwd -P)"
    }
compctl -U -K _z_zsh_tab_completion z

# zsh-syntax-highlighting
# --------------------------------------------------
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load oh-my-zsh plugins
# --------------------------------------------------
# source ~/.zsh/plugins/oh-my-zsh/plugins/tmux/tmux.plugin.zsh
# source ~/.zsh/plugins/oh-my-zsh/plugins/git/git.plugin.zsh
# source ~/.zsh/plugins/oh-my-zsh/plugins/colored-man/colored-man.plugin.zsh
#
# if [[ ${OSTYPE} == darwin* ]]; then
#     source ~/.zsh/plugins/oh-my-zsh/plugins/osx/osx.plugin.zsh
#     source ~/.zsh/plugins/oh-my-zsh/plugins/brew/brew.plugin.zsh
#     source ~/.zsh/plugins/oh-my-zsh/plugins/brew-cask/brew-cask.plugin.zsh
# fi

# Other settings
# --------------------------------------------------
# w3m HOME
export WWW_HOME="http://www.google.com"

# Base16 Shell
# BASE16_SHELL="${HOME}/.zsh/plugins/base16-shell/base16-ashes.dark.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
