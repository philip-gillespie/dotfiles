# .zshrc
# My personal zshell configuration
# stty eof undef
# Define the custom widget
use_exit() {
    # Print "hello world" directly to the terminal
    echo 'Use "exit" to leave the shell.'
    # Invalidate the buffer and force a prompt update
    zle -I
}

# Load the ZLE (Zsh Line Editor) module
zle -N use_exit

# Bind Ctrl-D to the custom widget
bindkey '^D' use_exit
# stty eof '^X^D'

# Install package manager if not here already
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Prompt
eval "$(oh-my-posh init zsh --config ~/.config/zsh/omp.theme.toml)"


# Syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# Completions
zinit light zsh-users/zsh-completions

autoload -U compinit && compinit
zinit cdreplay -q

# History
zinit light Aloxaf/fzf-tab

# Emacs keybindings
bindkey -e
# keybind history
bindkey '^j' history-search-backward
bindkey '^k' history-search-forward

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Aliasing
alias ls='ls --color'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # do not append if command follows whitespace
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt ignoreeof

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"


#  Catpuccin
# source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
