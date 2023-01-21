local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }
    use { 'folke/tokyonight.nvim' }
    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use { 'junegunn/fzf.vim' }
    use { 'neovim/nvim-lspconfig' }
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp' }

    require("mason").setup()
    require('mason-lspconfig').setup_handlers({ function(server)
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require('lspconfig')[server].setup({
            capabilities = capabilities,
        })
    end
    })
    local cmp = require("cmp");
    cmp.setup({
        sources = {{ name = "nvim_lsp" }},
        mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ['<C-l>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
        }),
    })
    vim.cmd('let mapleader = "\\<Space>"')
    vim.keymap.set('n', '<leader>h',  vim.lsp.buf.hover)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.cmd([[
command LspDefinition lua vim.lsp.buf.definition()
command LspFormatting lua vim.lsp.buf.formatting()
command LspReferences lua vim.lsp.buf.references()
command LspCodeAction lua vim.lsp.buf.code_action()
colorscheme tokyonight-night
set termguicolors
set foldmethod=indent
set nofoldenable
set number
set cursorline
set hlsearch
set incsearch
set backspace=start,eol,indent
set tabstop=4
set shiftwidth=4
set expandtab
    ]])

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)

