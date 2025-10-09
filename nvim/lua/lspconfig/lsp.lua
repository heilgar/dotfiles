-- =================================================================
-- LSP Server Configuration
-- =================================================================

local keymaps = require('lspconfig.keymaps')

-- Enable LSP servers
vim.lsp.enable({
    "lua_ls",
    "clangd",
    "ruff",
    "pyright",
    "tsserver",
    "terraformls",
    "dockerls",
    "yamlls",
    "biome",
})

-- =================================================================
-- LSP Attach Configuration
-- =================================================================

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Setup all keymaps
        keymaps.setup_keymaps(client, ev.buf)

        -- =================================================================
        -- Server-specific configurations
        -- =================================================================

        -- Disable hover for Ruff in favor of Pyright
        if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
        end
    end
})

-- =================================================================
-- Diagnostic Configuration
-- =================================================================

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
    },
    virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN },
        source = 'if_many',
        prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})
