# Standard Config
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

# Import Zplug
source ~/.zplug/init.zsh

# Theme
# https://github.com/starship/starship
eval "$(starship init zsh)"


# Plugins
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2

if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Aliases
alias cat='bat'
alias ls='exa --git --icons'
alias l='exa --git -l --icons'
alias la='exa --git -la --icons'
alias grep='rg'
alias du='dust'
alias ps='procs'
alias top='ytop'
alias find='fd'

# Env Vars
EDITOR='emacs'
HISTFILE='/home/nick/.zsh_history'
DENO_INSTALL="$HOME/.deno"

# Path Modifications
PATH=$PATH:"$HOME/.local/bin"
PATH=$PATH:"$HOME/.gem/ruby/2.7.0/bin"
PATH=$PATH:"$HOME/.emacs.d/bin"
PATH=$PATH:"$HOME/.yarn/bin"
PATH=$PATH:"$HOME/.cargo/bin"
PATH=$PATH:"$HOME/.go/bin"
PATH=$PATH:"$HOME/go/bin"
PATH=$PATH:"$DENO_INSTALL/bin:$PATH"

# Keybinds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
