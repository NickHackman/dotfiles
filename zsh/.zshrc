# Standard Config
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nick/.zshrc'

autoload -Uz compinit
compinit

# Import Zplug
source ~/.zplug/init.zsh

# Themes
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Plugins
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Aliases
alias cat='bat'
alias ls='exa --git'
alias l='exa --git -l'
alias la='exa --git -la'
alias grep='rg'
alias top='gotop'
alias find='fd'

# Env Vars
EDITOR='emacs'
HISTFILE='$HOME/.zsh_history'
GOPATH="$HOME/.go"
DENO_INSTALL="$HOME/.deno"

# Path Modifications
PATH=$PATH:"$HOME/.local/bin"
PATH=$PATH:"$HOME/.gem/ruby/2.7.0/bin"
PATH=$PATH:"$HOME/.emacs.d/bin"
PATH=$PATH:"$HOME/.yarn/bin"
PATH=$PATH:"$HOME/.cargo/bin"
PATH=$PATH:"$HOME/.go/bin"
PATH=$PATH:"$DENO_INSTALL/bin:$PATH"

# Keybinds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
