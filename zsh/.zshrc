# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "jeffreytse/zsh-vi-mode"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Neovim
export PATH=$HOME/local/nvim/bin:$PATH

# Catppuccin for zsh-syntax-highlighting
source ~/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh
# Catppuccin for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# Make sure to use the nightly version of Neovim in user space (still running pacman install as root)
export PATH="$HOME/.local/nvim/bin:$PATH"

# Aliases
## Eza
alias ls="eza -a"
alias ll="eza --long --header -a"
alias tree="eza --tree --level=2"
## Pygments
alias cat="pygmentize -g"
## Neovim
alias vim="nvim"
## Lazygit
alias lgit="lazygit"
## Fastfetch
alias neofetch="fastfetch"
## Bat
alias cat="bat"
## fzf
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"

fastfetch

if [[ -z $ZELLIJ ]]; then
    zellij
fi
