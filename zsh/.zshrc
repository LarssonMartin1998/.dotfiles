# Change the system default editor to nvim
export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

set_custom_keybindings() {
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[[A' history-search-backward
    bindkey '^[[B' history-search-forward

    # Reduce the key timeout delay
    KEYTIMEOUT=1

    # Unbind the <Esc>c sequence to prevent conflict with fzf-tab
    bindkey -r "^[c"
}

init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    [ -f ~/.zshrc_local ] && source ~/.zshrc_local
    eval "$(fzf --zsh)"
    eval "$(zoxide init --cmd cd zsh)"

    set_custom_keybindings
}

add_to_path() {
    if [[ -d $1 ]] && [[ ! $PATH =~ $1 ]]; then
        export PATH=$1:$PATH
    fi
}

# Workaround to make sure that the custom keybindings
# are persistent when switching modes in zsh-vi-mode ...
# It still breaks sometimes when exiting insert mode, but its better than not having it at all
zvm_after_init_commands+=(init)
zvm_after_select_vi_mode_commands+=(set_custom_keybindings)
zvm_after_zvm_after_lazy_keybindings_commands+=(set_custom_keybindings)

# Make homebrew installed packages available in the path on macOS
if  [[ "$(uname)" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Paths
add_to_path $HOME/.local/bin
add_to_path $HOME/.local/nvim/bin

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add powerlevel10k prompt
zinit ice depth=1;
# zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Add snippets
zinit snippet OMZP::git
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select-wrapped >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{z-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias vi="nvim"
alias c="clear"
alias s="source"
alias sz="source ~/.zshrc"
alias ls="eza -a --color=always"
alias ll="eza --long --header -a --color=always --icons"
alias tree="eza --tree --level=2 --color=always --icons"
alias lg="lazygit"
alias neofetch="fastfetch"
alias cat="bat"
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
# wl-copy and wl-paste doesn't exist on mac, and mac has pbcopy and pbpaste
if  [[ "$(uname)" == "Darwin" ]]; then
    alias wlc="pbcopy"
    alias wlp="pbpaste"
else
    alias wlc="wl-copy"
    alias wlp="wl-paste"
fi
alias pilot="gh copilot"
alias ps="gh copilot suggest"
alias pe="gh copilot explain"
alias fzfd="fd --type d --hidden --follow --exclude .git | fzf"

# Alias functions
vif() {
    nvim "$(fzf)"
}

pwdf() {
    echo "$(pwd)"/"$(fzf)"
}

get-bwp() {
    bw get password "$1"
}

bwp() {
    get-bwp "$1" | wlc
}

catc() {
    cat "$1" | wlc
}

cdf() {
    cd "$(fzfd)"
}

cpf() {
    if [ -z "$1" ]; then
        cp "$(fzf)" "$(fzfd)"
    else
        cp "$(fzf)" "$1"
    fi
}

mvf() {
    if [ -z "$1" ]; then
        mv "$(fzf)" "$(fzfd)"
    else
        mv "$(fzf)" "$1"
    fi
}

rmf() {
    rm "$(fzf)"
}

rmdf() {
    rm -rf "$(fzfd)"
}

# Check if tmux is already running or if the session is interactive
if [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
    # Create a new tmux session, if one doesnt exist, give it the main name, never attach to a session
    if tmux ls &> /dev/null; then
        tmux attach
    else
        tmux new-session -s main
    fi
fi

if [[ -n "$TMUX" ]]; then
    precmd() {
        local name
        name="$("$HOME/.config/tmux/tmux-rename-window.sh")"
        tmux rename-window "$name"
    }
fi

fastfetch
