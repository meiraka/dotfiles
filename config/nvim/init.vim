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
" Plug 'nanotech/jellybeans.vim'
" Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'cocopon/iceberg.vim'
Plug 'nathanaelkane/vim-indent-guides'  " indent view
Plug 'tpope/vim-surround'  " surroundings cs
Plug 'tpope/vim-fugitive'  " git
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
let g:lsp_text_edit_enabled = 0
autocmd BufWritePre <buffer>  call execute('LspCodeActionSync source.organizeImports')
autocmd BufWritePre <buffer> LspDocumentFormatSync
" Lang: Go
Plug 'mattn/vim-goimports'
" Lang: C++
Plug 'meiraka/vim-google-cpp-style-indent'
" Lang: Haskell
Plug 'kana/vim-filetype-haskell'
" Lang: Scala
Plug 'derekwyatt/vim-scala'
" Lang: Ansible
Plug 'chase/vim-ansible-yaml'
call plug#end()

function! OnVimEnter() abort
  " Run PlugUpdate every week automatically when entering Vim.
  if exists('g:plug_home')
    let l:filename = printf('%s/.vim_plug_update', g:plug_home)
    if filereadable(l:filename) == 0
      call writefile([], l:filename)
    endif

    let l:this_week = strftime('%Y_%V')
    let l:contents = readfile(l:filename)
    if index(l:contents, l:this_week) < 0
      call execute('PlugUpdate')
      call writefile([l:this_week], l:filename, 'a')
    endif
  endif
endfunction

autocmd VimEnter * call OnVimEnter()

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
" let g:jellybeans_overrides = {'background': {'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' }}
colorscheme iceberg
hi! Normal guibg=NONE

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
:map <Leader>f :Files<CR>
