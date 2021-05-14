call plug#begin('$HOME/.config/vim/plugged')
Plug 'justinmk/vim-sneak'
Plug 'preservim/nerdtree'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
call plug#end()

" vimtex
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_mathparen_enabled=1

let g:vimtex_compiler_latexmk = {
  \ 'options' : [
    \ '-pdf',
    \ '-shell-escape',
    \ '-synctex=1',
    \ '-interaction=nonstopmode',
  \ ],
\}

let g:vimtex_view_method='zathura'
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'

" UltiSnips
let g:UltiSnipsSnippetDirectories=[expand('$HOME/dotfiles/.config/vim/UltiSnips')]
