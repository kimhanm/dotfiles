" Keybindings
let maplocalleader = " "

" Alt key
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-k> <Esc>:m .-2<CR>==gi
inoremap <A-j> <Esc>:m .+1<CR>==gi
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-j> :m '>+1<CR>gv=gv

" Window
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

nnoremap <leader>t : NERDTreeToggle<CR>

" PLUGINS
"   UltiSnips
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<C-k>'
let g:UltiSnipsEditSplit='vertical'
inoremap <C-j> <C-o>:call UltiSnips#JumpForwards()<CR>


" Python
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>

