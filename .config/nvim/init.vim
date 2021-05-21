set runtimepath^=$HOME/.config/vim runtimepath+=$HOME/.config/vim/after
let &packpath = &runtimepath
source $HOME/.config/vim/.vimrc
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/keys.vim
source $HOME/.config/nvim/filetype.vim

let g:python3_host_prog = '/usr/bin/python3'
