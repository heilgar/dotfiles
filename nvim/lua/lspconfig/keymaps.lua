-- =================================================================
-- LSP Keymaps and Smart Code Actions
-- =================================================================

local M = {}

-- =================================================================
-- Helper Functions
-- =================================================================

local function get_active_clients(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.lsp.get_clients({ bufnr = bufnr })
end

local function has_client(client_name, bufnr)
    local clients = get_active_clients(bufnr)
    for _, client in ipairs(clients) do
        if client.name == client_name then
            return true
        end
    end
    return false
end

-- =================================================================
-- Smart Code Actions
-- =================================================================

local function smart_code_action(action_type)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_active_clients(bufnr)

    if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.WARN)
        return
    end

    -- Define action mappings per client
    local actions = {
        organize_imports = {
            ruff = { 'source.organizeImports.ruff' },
            ts_ls = { 'source.organizeImports' },
            pyright = { 'source.organizeImports' },
            eslint = { 'source.organizeImports' },
            biome = { 'source.organizeImports.biome' },
        },
        fix_all = {
            ruff = { 'source.fixAll.ruff' },
            eslint = { 'source.fixAll.eslint' },
            ts_ls = { 'source.fixAll' },
            biome = { 'source.fixAll.biome' },
        },
        remove_unused = {
            ts_ls = { 'source.removeUnused' },
            eslint = { 'source.removeUnused' },
        },
        add_missing = {
            ts_ls = { 'source.addMissingImports' },
            eslint = { 'source.addMissingImports' },
        },
    }

    -- Find the appropriate action for available clients
    local action_contexts = {}
    for _, client in ipairs(clients) do
        local client_actions = actions[action_type]
        if client_actions and client_actions[client.name] then
            for _, context in ipairs(client_actions[client.name]) do
                table.insert(action_contexts, context)
            end
        end
    end

    if #action_contexts > 0 then
        vim.lsp.buf.code_action({
            context = { only = action_contexts },
            apply = true,
        })
    else
        -- Fallback to general code actions
        vim.lsp.buf.code_action()
    end
end

function M.smart_format()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_active_clients(bufnr)

    -- Define preferred formatters per language
    local format_preferences = {
        python = { 'ruff', 'pyright' },
        typescript = { 'biome', 'ts_ls' },
        javascript = { 'biome', 'ts_ls' },
        typescriptreact = { 'biome', 'ts_ls' },
        javascriptreact = { 'biome', 'ts_ls' },
        json = { 'biome' },
        jsonc = { 'biome' },
        css = { 'biome' },
        html = { 'biome' },
        terraform = { 'terraformls' },
        lua = { 'lua_ls' },
        c = { 'clangd' },
        cpp = { 'clangd' },
        yaml = { 'yamlls' },
        dockerfile = { 'dockerls' },
    }

    local filetype = vim.bo[bufnr].filetype
    local preferred = format_preferences[filetype] or {}

    -- Find the preferred formatter
    local formatter_client = nil
    for _, pref in ipairs(preferred) do
        for _, client in ipairs(clients) do
            if client.name == pref and client:supports_method('textDocument/formatting') then
                formatter_client = client
                break
            end
        end
        if formatter_client then break end
    end

    -- Use preferred formatter or fallback to any available
    if formatter_client then
        vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c) return c.id == formatter_client.id end,
            timeout_ms = 3000,
        })
    else
        -- Fallback to any available formatter
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
    end
end



-- =================================================================
-- Main Keymap Setup Function
-- =================================================================

function M.setup_keymaps(client, bufnr)
    -- =================================================================
    -- LSP Navigation Keymaps
    -- =================================================================
    vim.keymap.set('n', 'jD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration' })
    vim.keymap.set('n', 'jd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
    vim.keymap.set('n', 'ji', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation' })
    vim.keymap.set('n', 'jr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Show references' })
    vim.keymap.set('n', '<leader>jt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Go to type definition' })

    -- =================================================================
    -- Universal Code Actions (Language-Aware)
    -- =================================================================
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code actions' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })

    -- Smart formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>cf', M.smart_format, { buffer = bufnr, desc = 'Format (smart)' })

    -- Smart code actions
    vim.keymap.set('n', '<leader>co', function()
        smart_code_action('organize_imports')
    end, { buffer = bufnr, desc = 'Organize imports (smart)' })

    vim.keymap.set('n', '<leader>cm', function()
        smart_code_action('add_missing')
    end, { buffer = bufnr, desc = 'Add missing imports (smart)' })

    vim.keymap.set('n', '<leader>cx', function()
        smart_code_action('fix_all')
    end, { buffer = bufnr, desc = 'Fix all issues (smart)' })

    -- =================================================================
    -- Documentation and Diagnostics
    -- =================================================================
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover documentation' })
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help (insert)' })

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Previous diagnostic' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Next diagnostic' })
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { buffer = bufnr, desc = 'Show diagnostic' })
    vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { buffer = bufnr, desc = 'Diagnostic quickfix' })

    -- =================================================================
    -- Workspace Management
    -- =================================================================
    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Add workspace folder' })
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder,
        { buffer = bufnr, desc = 'Remove workspace folder' })
    vim.keymap.set('n', '<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = bufnr, desc = 'List workspace folders' })

    -- =================================================================
    -- Advanced Features
    -- =================================================================

    -- Inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint') then
        vim.keymap.set('n', '<leader>ih', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'Toggle inlay hints' })
    end
end

return M
