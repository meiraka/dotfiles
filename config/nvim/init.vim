let $LANG="en_US.utf8"
let $LC_LANG="en_US.utf8"
let $LC_ALL="en_US.utf8"

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/bundle')
Plug 'meiraka/le_petit_chaperonrouge.vim'
" Plug 'altercation/vim-colors-solarized'
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/vimshell.vim'
Plug 'scrooloose/syntastic'  " syntax checker
let g:syntastic_python_checkers = ['python', 'pylint', 'flake8', 'pep257']
let g:syntastic_cpp_checkers = ['gcc', 'cpplint', 'clang_check']
let g:syntastic_cpp_cpplint_args =
\ '--verbose=3 filter=-legal/copyright --extensions=hpp,cpp'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let s:user = 'y'
let g:syntastic_cpp_include_dirs = ['/home/'.s:user.'/include']
let g:syntastic_go_checkers = ['go', 'gofmt', 'golint', 'govet']
let g:syntastic_javascript_checkers = ['eslint']

Plug 'itchyny/lightline.vim'  " statusline
set laststatus=2
let g:lightline =
\ {'colorscheme': 'wombat',
\  'active':
\    {'right':
\        [['syntastic', 'lineinfo'],
\         ['percent'],
\         ['fileformat', 'fileencoding']]},
\  'component_expand': {'syntastic': 'SyntasticStatuslineFlag'},
\  'component_type': {'syntasitc': 'error'}}
let g:syntastic_mode_map = {'mode': 'passive'}
function! s:show_syntasitc_errors()
  SyntasticCheck
  call lightline#update()
endfunction
augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost * call s:show_syntasitc_errors()
augroup END
Plug 'nathanaelkane/vim-indent-guides'  " indent view
Plug 'tpope/vim-surround'  " surroundings cs
Plug 'tpope/vim-fugitive'  " git
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
" Lang: C++
Plug 'meiraka/vim-google-cpp-style-indent'
Plug 'justmao945/vim-clang'
" Plug 'Rip-Rip/clang_complete'
" let g:clang_library_path = expand('~/lib')
" let g:clang_complete_auto = 1
" Lang: Python
Plug 'davidhalter/jedi-vim'
" Lang: Haskell
Plug 'kana/vim-filetype-haskell'
" Lang: Vim
Plug 'vim-jp/vimdoc-ja'
" Lang: Scala
Plug 'derekwyatt/vim-scala'
Plug 'ktvoelker/sbt-vim'
" Lang: Go
Plug 'vim-jp/vim-go-extra'
autocmd FileType go autocmd BufWritePre <buffer> Fmt
" Lang: Ansible
Plug 'chase/vim-ansible-yaml'
call plug#end()

set termguicolors
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set t_Co=256
set guifont="Ricty\ bold\ 14"
set guifontwide="Ricty\ bold\ 14"
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set background=dark
colorscheme le_petit_chaperonrouge

set number
set cursorline
set hlsearch
set incsearch
set backspace=start,eol,indent
set tabstop=4
set shiftwidth=4
set expandtab
set path=
" set ambiwidth='single'


