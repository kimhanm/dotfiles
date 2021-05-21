" Basic Settings
set encoding=utf-8
set nocompatible " use vim, over vi
set hidden " keeps bufers alive when abandoned, acces with :ls and :bN for N number
set viminfo+=n$HOME/.config/vim/.viminfo

filetype plugin indent on
syntax on

" Behaviour
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Appearance
set number relativenumber " enables relative line numbers
set statusline=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]

