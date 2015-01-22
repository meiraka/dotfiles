"""meiraka vim config."""

import os
import viimproved as vim
import subprocess

BUNDLE_DIR = os.path.expanduser('~/.vim-plugins')

if vim.functions.has('gui_running') == '1':
    vim.settings.background = 'light'
    vim.settings.guifont = "Migu 1M bold 12"
    vim.settings.guifontwide = "Migu 1M bold 12"
else:
    vim.settings.background = 'dark'

vim.settings.t_Co = 256
vim.settings.number = True
vim.settings.cursorline = True

vim.commands.syntax('on')
vim.settings.hlsearch = True
vim.settings.incsearch = True
vim.settings.backspace = 'start,eol,indent'
vim.settings.tabstop = 4
vim.settings.shiftwidth = 4
vim.settings.expandtab = True
# vim.settings.ambiwidth = 'single'

plugin_manager_path = os.path.join(BUNDLE_DIR, 'neobundle.vim')
if vim.functions.has('vim_starting'):
    if vim.settings.compatible:
        vim.settings.compatible = False
    # fetch neobundle and add runtimepath
    if not os.path.exists(plugin_manager_path):
        try:
            subprocess.check_call(
                "git clone "
                "https://github.com/Shougo/neobundle.vim "
                "%s" % plugin_manager_path)
        except:
            pass
    if os.path.exists(plugin_manager_path):
        vim.settings.runtimepath = ','.join([vim.settings.runtimepath,
                                             plugin_manager_path])
    else:
        print ('failed to load plugin manager to %s'
               % plugin_manager_path)

if os.path.exists(plugin_manager_path):
    g = vim.globals.variables
    neobundle = vim.autoloads.neobundle.functions
    NeoBundleFetch, NeoBundle, NeoBundleCheck = [
        getattr(vim.commands, i) for i in
        ['NeoBundleFetch', 'NeoBundle', 'NeoBundleCheck']]

    neobundle.begin(os.path.expanduser(BUNDLE_DIR))
    NeoBundleFetch("'Shougo/neobundle.vim'")
    NeoBundle("'meiraka/vim-hysteric-colors'")
    NeoBundle("'Shougo/vimproc',{'build':{'unix':'make -f make_unix.mak'"
              ",'mac':'make -f make_mac.mak'}}")

    if vim.functions.has("lua") == '1':
        NeoBundle("'Shougo/neocomplete.vim'")
    else:
        NeoBundle("'Shougo/neocomplcache'")

    if vim.variables.version >= 704:
        NeoBundle("'Shougo/vimshell.vim'")
        NeoBundle("'ujihisa/vimshell-ssh'")
    NeoBundle("'scrooloose/nerdtree'")

    # syntax checker.
    # :SyntasticInfo to show checkers
    NeoBundle("'scrooloose/syntastic'")
    g.syntastic_python_checkers = ['python', 'pylint',
                                   'flake8', 'pep257']
    g.syntastic_cpp_cpplint_args = ('--verbose=3 '
                                    'filter=-legal/copyright '
                                    '--extensions=hpp,cpp ')
    g.syntastic_cpp_check_header = 1
    g.syntastic_cpp_no_include_search = 1
    g.syntastic_cpp_auto_refresh_includes = 1

    # Status line
    NeoBundle("'itchyny/lightline.vim'")
    vim.settings.laststatus = 2
    g.lightline = {'colorscheme': 'wombat',
                   'active': {'right': [['syntastic', 'lineinfo'],
                                        ['percent'],
                                        ['fileformat', 'fileencoding',
                                         'filetype']]},
                   'component_expand': {
                       'syntastic': 'SyntasticStatuslineFlag'},
                   'component_type': {'syntastic': 'error'}}

    g.syntastic_mode_map = {'mode': 'passive'}

    def show_syntastic_errors():
        """check syntastic and show errors to lightline."""
        vim.commands.SyntasticCheck()
        vim.autoloads.lightline.functions.update()
    vim.autocmd.bind('BufWritePost', '*',
                     show_syntastic_errors, [])

    # NeoBundle("'kien/ctrlp.vim'")
    NeoBundle("'nathanaelkane/vim-indent-guides'")
    g.indent_guides_enable_on_vim_startup = 1
    g.indent_guides_start_level = 2
    g.indent_guides_color_change_percent = 30
    g.indent_guides_guide_size = 1

    NeoBundle("'tpope/vim-fugitive'")

    # Lang: C++
    NeoBundle("'meiraka/vim-google-cpp-style-indent'")

    # Lang: Python
    NeoBundle("'davidhalter/jedi-vim'")
    vim.autocmd.bind('FileType python', '',
                     setattr, [vim.buffer.variables, 'did_ftplugin', '1'])
    vim.autoloads.jedi.variables.use_tabs_not_buffers = 0
    NeoBundle("'nvie/vim-flake8'")

    # Lang: Haskell
    NeoBundle("'kana/vim-filetype-haskell'")
    # NeoBundle("'raichoo/haskell-vim'")
    # vim.globals.variables.haskell_enable_quantification = 1
    # vim.globals.variables.haskell_enable_arrowsyntax = 1

    # Lang: Vim
    NeoBundle("'vim-jp/vimdoc-ja'")

    # Lang: Scala
    NeoBundle("'derekwyatt/vim-scala'")

    neobundle.end()
    vim.commands.filetype("plugin", "indent", "on")
    NeoBundleCheck()

vim.commands.colorscheme("tricolore")


def reload():
    """Reload vimrc file."""
    vim.commands.source('~/.vimrc')
