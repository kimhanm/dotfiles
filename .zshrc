# Basic settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob
bindkey -v '^?' backward-delete-char # Vim backspace over Vi backspace
unsetopt autocd notify
zstyle :compinstall filename '/home/hk/.zshrc'

autoload -Uz compinit
compinit
PROMPT='[%F{yellow}%n%f@%F{cyan}%m%f %F{blue}%B%~%b%f] %# '

# Source other files
[ -f $HOME/.config/zsh/aliases ] && source $HOME/.config/zsh/aliases

# PATH variables

export PATH"=$HOME/.local/bin:/usr/local/share/texlive/2021/bin/x86_64-linux:$PATH"
export MANPATH"=/usr/local/share/texlive/2021/texmf/doc/man:$MANPATH"
export INFOPATH"=/usr/local/share/texlive/2021/texmf/doc/info:$INFOPATH"



#  fzf
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh


export FZF_DEFAULT_OPTS="
  --layout=reverse
  --bind '?:toggle-preview'
"

export FZF_BASE_COMMAND='fd -I -H --ignore-file /usr/share/fzf/fzfignore'
export FZF_DEFAULT_COMMAND="$FZF_BASE_COMMAND -t f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_BASE_COMMAND -t d"

__fzf_compgen_path() {
  fd -H . "$1"
}

__fzf_compgen_dir() {
  fd --type d -H . "$1"
}

vim-fzf-widget() {
  files=$(eval $FZF_CTRL_T_COMMAND | fzf -m) && nvim $files
  zle reset-prompt
}
zle     -N    vim-fzf-widget
bindkey "^[e" vim-fzf-widget

xdg-fzf-widget() {
  files=$(eval $FZF_CTRL_T_COMMAND | fzf) && xdg-open $files
  zle reset-prompt
}
zle     -N    xdg-fzf-widget
bindkey "^[x" xdg-fzf-widget


if [ -e /home/hk/.nix-profile/etc/profile.d/nix.sh ]; then . /home/hk/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
