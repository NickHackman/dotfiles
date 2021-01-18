set -U fish_color_normal 282C34
set -U fish_color_command 61AFEF
set -U fish_color_error E06C75
set -U fish_color_comment ABB2BF
set -U fish_color_quote 98C379
set -U fish_color_end C678DD
set -U fish_color_param 56B6C2
set -U fish_color_redirection E5C07B

alias ls "exa --icons --git"
alias fk "fuck"
alias l "exa --icons --git -l"
alias tls "tmux ls"
alias la "exa --icons --git -la"
alias cat "bat"
alias grep "rg"
alias find "fd"
alias du "dust"
alias ps "procs"
alias top "btm"
alias vim "nvim"
alias vi "nvim"
alias ta "tmux a -t (env FZF_DEFAULT_COMMAND='tmux ls -F \"#S\"' fzf -1 --no-multi --prompt=\"Select a session: \")"
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"

alias vi "nvim"
alias vim "nvim"

alias copy "xclip -selection clipboard"
alias "..." "cd ../.."

set -x EDITOR nvim
set -x GOPATH ~/.go

fish_vi_key_bindings
starship init fish | source

thefuck --alias | source
