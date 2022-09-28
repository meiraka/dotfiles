vim9script

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

plug#begin('~/.config/nvim/bundle')
Plug 'meiraka/le_petit_chaperonrouge.vim'
# Plug 'nanotech/jellybeans.vim'
# Plug 'frankier/neovim-colors-solarized-truecolor-only'
# Plug 'cocopon/iceberg.vim'
# Plug '4513ECHO/vim-colors-hatsunemiku'
# Plug 'gruvbox-community/gruvbox'
Plug 'AlessandroYorba/Alduin'
Plug 'nathanaelkane/vim-indent-guides'  # indent view
Plug 'tpope/vim-surround'  # surroundings cs
Plug 'tpope/vim-fugitive'  # git
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
Plug 'simeji/winresizer' # window resize
# LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
g:lsp_async_completion = 1
g:lsp_signs_enabled = 1
g:lsp_diagnostics_echo_cursor = 1
g:lsp_diagnostics_enabled = 1
g:lsp_highlight_references_enabled = 1
g:lsp_text_edit_enabled = 0
autocmd BufWritePre <buffer>  execute('LspCodeActionSync source.organizeImports')
autocmd BufWritePre <buffer> LspDocumentFormatSync
# Lang: Go
Plug 'mattn/vim-goimports'
# Lang: C++
Plug 'meiraka/vim-google-cpp-style-indent'
# Lang: Haskell
Plug 'kana/vim-filetype-haskell'
# Lang: Scala
Plug 'derekwyatt/vim-scala'
# Lang: Ansible
Plug 'chase/vim-ansible-yaml'
plug#end()

def OnVimEnter()
  # Run PlugUpdate every week automatically when entering Vim.
  if exists('g:plug_home')
    var filename = printf('%s/.vim_plug_update', g:plug_home)
    if filereadable(filename) == 0
      writefile([], filename)
    endif

    var this_week = strftime('%Y_%V')
    var contents = readfile(filename)
    if index(contents, this_week) < 0
      execute('PlugUpdate')
      writefile([this_week], filename, 'a')
    endif
  endif
enddef

autocmd VimEnter * OnVimEnter()

autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost    l* lwindow

set termguicolors
# var $NVIM_TUI_ENABLE_TRUE_COLOR=1
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
# g:jellybeans_overrides = {'background': {'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' }}
# colorscheme gruvbox
colorscheme alduin
# hi! Normal guibg=NONE

set number
set cursorline
set hlsearch
set incsearch
set backspace=start,eol,indent
set tabstop=4
set shiftwidth=4
set expandtab
set path=
# set ambiwidth='single'

g:mapleader = "\<Space>"
map <Leader>t :silent make\|redraw!\|cc<CR>
map <Leader>i :LspPeekDefinition<CR>
map <Leader>d :LspDocumentDiagnostics<CR>
map <Leader>r :LspRename<CR>
map <Leader>f :Files<CR>
map <Leader>b :Buffers<CR>

def g:SyncColors()
    vs
    SyncFZFColors()
    sp
    SyncDirColors()
    vs
    SyncTermColors()
enddef

def SyncTermColors()
    var target = "~/.config/kitty/kitty.conf"
    if !bufexists(target)
        execute 'badd' target
    endif
    execute 'buffer' '+%s/^foreground\ \\+.*/foreground\ ' .. synIDattr(synIDtrans(hlID("Normal")), "fg#") .. '/g' target
    execute 'buffer' '+%s/^background\ \\+.*/background\ ' .. synIDattr(synIDtrans(hlID("Normal")), "bg#") .. '/g' target
    execute 'buffer' '+%s/^selection_foreground\ \\+.*/selection_foreground\ ' .. synIDattr(synIDtrans(hlID("Search")), "fg#")  .. '/g' target
    execute 'buffer' '+%s/^selection_background\ \\+.*/selection_background\ ' .. synIDattr(synIDtrans(hlID("Search")), "bg#")  .. '/g' target
    execute 'buffer' '+%s/^cursor\ \\+.*/cursor\ ' .. synIDattr(synIDtrans(hlID("Cursor")), "bg#") .. '/g' target
    execute 'buffer' '+%s/^active_tab_foreground\ \\+.*/active_tab_foreground\ ' .. synIDattr(synIDtrans(hlID("TabLineSel")), "fg#") .. '/g' target
    execute 'buffer' '+%s/^active_tab_background\ \\+.*/active_tab_background\ ' .. synIDattr(synIDtrans(hlID("TabLineSel")), "bg#") .. '/g' target
    execute 'buffer' '+%s/^inactive_tab_foreground\ \\+.*/inactive_tab_foreground\ ' .. synIDattr(synIDtrans(hlID("TabLineFill")), "fg#") .. '/g' target
    execute 'buffer' '+%s/^inactive_tab_background\ \\+.*/inactive_tab_background\ ' .. synIDattr(synIDtrans(hlID("TabLineFill")), "bg#") .. '/g' target
    execute 'buffer' '+%s/^tab_bar_background\ \\+.*/tab_bar_background\ ' .. synIDattr(synIDtrans(hlID("TabLine")), "bg#") .. '/g' target

    execute 'buffer' '+%s/^color0\ \\+.*/color0\ ' .. g:terminal_ansi_colors[0] .. '/g' target
    execute 'buffer' '+%s/^color1\ \\+.*/color1\ ' .. g:terminal_ansi_colors[1] .. '/g' target
    execute 'buffer' '+%s/^color2\ \\+.*/color2\ ' .. g:terminal_ansi_colors[2] .. '/g' target
    execute 'buffer' '+%s/^color3\ \\+.*/color3\ ' .. g:terminal_ansi_colors[3] .. '/g' target
    execute 'buffer' '+%s/^color4\ \\+.*/color4\ ' .. g:terminal_ansi_colors[4] .. '/g' target
    execute 'buffer' '+%s/^color5\ \\+.*/color5\ ' .. g:terminal_ansi_colors[5] .. '/g' target
    execute 'buffer' '+%s/^color6\ \\+.*/color6\ ' .. g:terminal_ansi_colors[6] .. '/g' target
    execute 'buffer' '+%s/^color7\ \\+.*/color7\ ' .. g:terminal_ansi_colors[7] .. '/g' target
    execute 'buffer' '+%s/^color8\ \\+.*/color8\ ' .. g:terminal_ansi_colors[8] .. '/g' target
    execute 'buffer' '+%s/^color9\ \\+.*/color9\ ' .. g:terminal_ansi_colors[9] .. '/g' target
    execute 'buffer' '+%s/^color10\ \\+.*/color10\ ' .. g:terminal_ansi_colors[10] .. '/g' target
    execute 'buffer' '+%s/^color11\ \\+.*/color11\ ' .. g:terminal_ansi_colors[11] .. '/g' target
    execute 'buffer' '+%s/^color12\ \\+.*/color12\ ' .. g:terminal_ansi_colors[12] .. '/g' target
    execute 'buffer' '+%s/^color13\ \\+.*/color13\ ' .. g:terminal_ansi_colors[13] .. '/g' target
    execute 'buffer' '+%s/^color14\ \\+.*/color14\ ' .. g:terminal_ansi_colors[14] .. '/g' target
    execute 'buffer' '+%s/^color15\ \\+.*/color15\ ' .. g:terminal_ansi_colors[15] .. '/g' target
enddef

def SyncFZFColors()
    var target = "~/.zshenv"
    if !bufexists(target)
        execute 'badd' target
    endif
    var opts = split(fzf#wrap()["options"], " ")
    for opt in opts
        if stridx(opt, "--color") > 0
            execute 'buffer' '+%s/^export\ FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS.\\+/export\ FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS\ ' .. fnameescape(opt) .. '"/g' target
        endif
    endfor
enddef

def SyncDirColors()
    var target = "~/.dir_colors"
    if !bufexists(target)
        execute 'badd' target
    endif
    execute 'buffer' '+%delete' target
    var id = bufnr(target)
    var terms = ['Eterm', 'ansi', 'color-xterm', 'con132x25', 'con132x30', 'con132x43', 'con132x60', 'con80x25', 'con80x28', 'con80x30', 'con80x43', 'con80x50', 'con80x60', 'cons25', 'console', 'cygwin', 'dtterm', 'eterm-color', 'gnome', 'gnome-256color', 'hurd', 'jfbterm', 'konsole', 'kterm', 'linux', 'linux-c', 'mach-color', 'mach-gnu-color', 'mlterm', 'putty', 'putty-256color', 'rxvt', 'rxvt-256color', 'rxvt-cygwin', 'rxvt-cygwin-native', 'rxvt-unicode', 'rxvt-unicode-256color', 'rxvt-unicode256', 'screen', 'screen-256color', 'screen-256color-bce', 'screen-bce', 'screen-w', 'screen.Eterm', 'screen.rxvt', 'screen.linux', 'st', 'st-256color', 'terminator', 'vt100', 'xterm', 'xterm-16color', 'xterm-256color', 'xterm-88color', 'xterm-color', 'xterm-debian']
    for term in terms
        appendbufline(id, '$', ['TERM ' .. term])
    endfor
    appendbufline(id, '$', ['RESET 0'])
    appendbufline(id, '$', [DirColor('DIR',                   '00', 'Directory')])
    appendbufline(id, '$', [DirColor('STICKY',                '01', 'Directory')])
    appendbufline(id, '$', [DirColor('STICKY_OTHER_WRITABLE', '04', 'Directory')])
    appendbufline(id, '$', [DirColor('NORMAL',                '00', 'Normal')])
    appendbufline(id, '$', [DirColor('LINK',                  '04', 'Normal')])
    appendbufline(id, '$', [DirColor('ORPHAN',                '04', 'ErrorMsg')])
    appendbufline(id, '$', [DirColor('MISSING',               '04', 'ErrorMsg')])
    appendbufline(id, '$', [DirColor('EXEC',                  '00', 'Function')])
    appendbufline(id, '$', [DirColor('SETUID',                '01', 'Function')])
    appendbufline(id, '$', [DirColor('SETGID',                '01', 'Function')])
    appendbufline(id, '$', [DirColor('FIFO',                  '04', 'Special')])
    appendbufline(id, '$', [DirColor('SOCK',                  '04', 'Special')])
    appendbufline(id, '$', [DirColor('CHAR',                  '04', 'DiffChange')])
    appendbufline(id, '$', [DirColor('BLOCK',                 '04', 'DiffAdd')])
    for n in ['*TODO', '*README.md', '*README.rst', '*README']
        appendbufline(id, '$', [DirColor(n,                   '00', 'Question')])
    endfor
    for n in ['.go', '.py', '.c', '.cc', '.cpp', '.hs', '.h', '.hh', '.hpp', '.java', '.hs']
        appendbufline(id, '$', [DirColor(n,                   '00', 'String')])
    endfor
    for n in ['.pyc', '.o', '.d', '.hi']
        appendbufline(id, '$', [DirColor(n,                   '00', 'Comment')])
    endfor
enddef

def DirColor(name: string, mode: string, label: string): string
    var fg = synIDattr(synIDtrans(hlID(label)), "fg#")
    var bg = synIDattr(synIDtrans(hlID(label)), "bg#")
    if empty(bg) && empty(fg)
        throw 'dircolor: no color for ' .. label
    endif
    var ret = name .. ' ' .. mode
    if !empty(bg)
        ret = ret .. ";48;2;" .. RGB(bg, ';')
    endif
    if !empty(fg)
        ret = ret .. ";38;2;" .. RGB(fg, ';')
    endif
    return ret
enddef

def RGB(hex: string, joiner: string): string
    return str2nr(hex[1 : 2], 16) .. joiner .. str2nr(hex[3 : 4], 16) .. joiner .. str2nr(hex[5 : 6], 16)
enddef
