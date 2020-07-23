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
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'nathanaelkane/vim-indent-guides'  " indent view
Plug 'tpope/vim-surround'  " surroundings cs
Plug 'tpope/vim-fugitive'  " git
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
let g:lsp_async_completion = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_highlight_references_enabled = 1
autocmd BufWritePre <buffer>  call execute('LspCodeActionSync source.organizeImports')
autocmd BufWritePre <buffer> LspDocumentFormatSync
" Lang: Go
Plug 'mattn/vim-goimports'
" Lang: C++
Plug 'meiraka/vim-google-cpp-style-indent'
" Lang: Haskell
Plug 'kana/vim-filetype-haskell'
" Lang: Vim
Plug 'vim-jp/vimdoc-ja'
" Lang: Scala
Plug 'derekwyatt/vim-scala'
" Lang: Ansible
Plug 'chase/vim-ansible-yaml'
" Lang: CSS
Plug 'kewah/vim-stylefmt'
call plug#end()

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

set termguicolors
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set t_Co=256
set t_ut=
set guifont="Ricty\ bold\ 14"
set guifontwide="Ricty\ bold\ 14"
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set background=dark
if has('nvim')
  set scrollback=100000
endif
set wildmode=list:longest,full
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

let mapleader = "\<Space>"
:map <Leader>t :silent make\|redraw!\|cc<CR>
:map <Leader>i :LspPeekDefinition<CR>
:map <Leader>d :LspDocumentDiagnostics<CR>
:map <Leader>r :LspRename<CR>
