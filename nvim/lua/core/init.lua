vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Critical startup requirements (load immediately)
require('core.python_venv')
require('core.lazy')
require('core.options')
require('core.keymaps')  -- Load basic keymaps immediately
require('core.autocmds')
require('heilgar')
require('lspconfig')

