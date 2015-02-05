"""meiraka vim config."""

import os
import pprint
import subprocess
import viimproved as vim

BUNDLE_DIR = os.path.expanduser('~/.vim-plugins')

plugin_manager_path = os.path.join(BUNDLE_DIR, 'neobundle.vim')
if vim.functions.has('vim_starting') == '1':
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

    def nbwrap(func):
        """Return function that decorate arguments with nb()."""
        def nb(args):
            """Convert python data to NeoBundle args."""
            pout = pprint.pformat(args, 0).replace(u'\n', u'')
            if pout[0] == u'(' and pout[-1] == u')':
                return pout[1:-1]
            else:
                return pout

        def wrapfunc(*args):
            if len(args) == 0:
                func()
            elif len(args) == 1:
                func(nb(args[0]))
            else:
                func(nb(args))
        return wrapfunc

    NeoBundleFetch, NeoBundle, NeoBundleCheck = [
        nbwrap(getattr(vim.commands, i)) for i in
        ['NeoBundleFetch', 'NeoBundle', 'NeoBundleCheck']]

    neobundle.begin(os.path.expanduser(BUNDLE_DIR))
    NeoBundleFetch('Shougo/neobundle.vim')
    NeoBundle('meiraka/vim-hysteric-colors')
    NeoBundle('Shougo/vimproc',
              {'build': {'unix': 'make -f make_unix.mak',
               'mac': 'make -f make_mac.mak'}})

    if vim.functions.has("lua") == '1':
        NeoBundle('Shougo/neocomplete.vim', {'rev': 'ver.1.1'})

    if int(vim.variables.version) >= 704:
        NeoBundle('Shougo/vimshell.vim')
        NeoBundle('ujihisa/vimshell-ssh')
    NeoBundle('scrooloose/syntastic')  # syntax checker
    NeoBundle('itchyny/lightline.vim')  # statusline
    NeoBundle('nathanaelkane/vim-indent-guides')  # indent view
    NeoBundle('tpope/vim-fugitive')  # git

    # Lang: C++
    NeoBundle('meiraka/vim-google-cpp-style-indent')

    # Lang: Python
    NeoBundle('davidhalter/jedi-vim')
    NeoBundle('nvie/vim-flake8')

    # Lang: Haskell
    NeoBundle('kana/vim-filetype-haskell')

    # Lang: Vim
    NeoBundle('vim-jp/vimdoc-ja')

    # Lang: Scala
    NeoBundle('derekwyatt/vim-scala')

    neobundle.end()
    vim.commands.filetype("plugin", "indent", "on")
    NeoBundleCheck()

    if neobundle.is_installed('neocomplete.vim') == '1':
        vim.autoloads.neocomplete.variables.enable_at_startup = 1
    if neobundle.is_installed('vim-indent-guides') == '1':
        g.indent_guides_enable_on_vim_startup = 1
        g.indent_guides_start_level = 2
        g.indent_guides_color_change_percent = 30
        g.indent_guides_guide_size = 1
    if neobundle.is_installed('syntastic') == '1':
        g.syntastic_python_checkers = ['python', 'pylint',
                                       'flake8', 'pep257']
        g.syntastic_cpp_cpplint_args = ('--verbose=3 '
                                        'filter=-legal/copyright '
                                        '--extensions=hpp,cpp ')
        g.syntastic_cpp_check_header = 1
        g.syntastic_cpp_no_include_search = 1
        g.syntastic_cpp_auto_refresh_includes = 1

        def apply_path_to_syntastic():
            """Apply current vim path to syntastic."""
            g.syntastic_cpp_include_dirs = [
                i for i in vim.settings.path.split(',') if i]

        vim.autocmd.bind('FileType', 'cpp', apply_path_to_syntastic, [])

    if neobundle.is_installed('lightline.vim') == '1':
        vim.settings.laststatus = 2
        g.lightline = {'colorscheme': 'wombat',
                       'active': {'right': [['syntastic', 'lineinfo'],
                                            ['percent'],
                                            ['fileformat', 'fileencoding',
                                             'filetype']]},
                       'component_expand': {
                           'syntastic': 'SyntasticStatuslineFlag'},
                       'component_type': {'syntastic': 'error'}}
        if neobundle.is_installed('syntastic') == '1':
            g.syntastic_mode_map = {'mode': 'passive'}

            def show_syntastic_errors():
                """check syntastic and show errors to lightline."""
                vim.commands.SyntasticCheck()
                vim.autoloads.lightline.functions.update()

            vim.autocmd.bind('BufWritePost', '*',
                             show_syntastic_errors, [])

    if (neobundle.is_installed('jedi-vim') == '1' and
            neobundle.is_installed('neocomplete.vim') == '1'):
        vim.autocmd.bind('FileType', 'python',
                         vim.commands.setlocal, ['omnifunc=jedi#completions'])
        vim.autoloads.jedi.variables.completions_enabled = 0
        vim.autoloads.jedi.variables.auto_vim_configuration = 0
        vim.autoloads.neocomplete.variables.force_omni_input_patterns = {
            'python': '\%([^. \t]\.\|^\s*@\|'
                      '^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'}

    vim.commands.colorscheme("le_petit_chaperonrouge")

if vim.functions.has('gui_running') == '1':
    vim.settings.background = 'light'
    vim.settings.guifont = "Ricty\ bold\ 12"
    vim.settings.guifontwide = "Ricty\ bold\ 12"
else:
    vim.settings.background = 'dark'

vim.settings.t_Co = 256
vim.settings.number = True
vim.settings.cursorline = True

vim.commands.filetype('plugin', 'indent', 'on')
vim.commands.syntax('on')
vim.settings.hlsearch = True
vim.settings.incsearch = True
vim.settings.backspace = 'start,eol,indent'
vim.settings.tabstop = 4
vim.settings.shiftwidth = 4
vim.settings.expandtab = True
user = 'y'
vim.settings.path += ',/home/{0}/include'.format(user)
# vim.settings.ambiwidth = 'single'


def reload():
    """Reload vimrc file."""
    vim.commands.source('~/.vimrc')
