set encoding=utf-8
set fileencodings=utf-8,iso-8859-1,utf-16,euc-jp,cp932
filetype on

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command='goimports'
