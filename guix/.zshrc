# Basic settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob
#bindkey -v '^?' backward-delete-char # Vim backspace over Vi backspace
unsetopt autocd notify
zstyle :compinstall filename '/home/hk/.zshrc'

autoload -Uz compinit
compinit
PROMPT='[%F{yellow}%n%f@%F{cyan}%m%f %F{blue}%B%~%b%f] %# '

# Source other files
[ -f $HOME/.config/zsh/aliases ] && source $HOME/.config/zsh/aliases

# PATH variables




