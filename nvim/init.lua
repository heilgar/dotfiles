vim.loader.enable()

vim.api.nvim_set_current_dir(vim.env.PWD)

require("core")
require('lspconfig')
