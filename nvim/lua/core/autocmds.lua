local utils = require('core.utils')

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 🔥 BLAZING FAST PERFORMANCE THRESHOLDS 🔥
local MAX_FILE_SIZE_FOR_FORMAT = 50 * 1024 -- Reduced to 50KB for speed
local MAX_LINES_FOR_HEAVY_OPS = 1000       -- Reduced to 1000 lines for speed

-- ⚡ LIGHTNING-FAST YANK HIGHLIGHT ⚡
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = 'YankHighlight',
    callback = function()
        -- Reduced timeout for faster visual feedback
        vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 })
    end
})

-- 🚀 ULTRA-FAST FILE CLEANUP 🚀
augroup('AutoTrim', { clear = true })

-- Optimized functions for maximum speed
local function ensure_single_trailing_newline()
    -- Skip for large files
    if vim.fn.line('$') > MAX_LINES_FOR_HEAVY_OPS then return end

    local last_line = vim.fn.line('$')
    local last_line_content = vim.fn.getline(last_line)

    -- Fast cleanup
    while last_line > 1 and last_line_content == '' do
        vim.fn.deletebufline('%', last_line)
        last_line = last_line - 1
        last_line_content = vim.fn.getline(last_line)
    end

    if last_line_content ~= '' then
        vim.fn.append(last_line, '')
    end
end

local function trim_trailing_whitespace()
    -- Skip for large files
    if vim.fn.line('$') > MAX_LINES_FOR_HEAVY_OPS then return end

    local save_cursor = vim.fn.getpos(".")
    -- Fast whitespace removal
    pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
    vim.fn.setpos(".", save_cursor)
end

local function ensure_lf_line_endings()
    if vim.bo.fileformat ~= 'unix' then
        vim.bo.fileformat = 'unix'
    end
end

-- Blazing fast file size check
local function is_file_too_large()
    -- Quick checks first
    local line_count = vim.fn.line('$')
    if line_count > MAX_LINES_FOR_HEAVY_OPS then return true end

    local file_size = vim.fn.getfsize(vim.fn.expand('%:p'))
    return file_size > MAX_FILE_SIZE_FOR_FORMAT
end

-- ⚡ LIGHTNING-FAST FORMATTING ⚡
local function format_file()
    -- Quick exit for large files or if marked as large
    if is_file_too_large() or vim.b.large_file then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    -- Use Prettier for JS/TS projects if available
    if filetype == "javascript" or filetype == "typescript" or
        filetype == "javascriptreact" or filetype == "typescriptreact" or
        filetype == "json" or filetype == "css" or filetype == "html" then
        -- Check if prettier is available and there's a config file
        local prettier_config = vim.fn.findfile('.prettierrc', '.;') ~= '' or
            vim.fn.findfile('.prettierrc.json', '.;') ~= '' or
            vim.fn.findfile('.prettierrc.js', '.;') ~= '' or
            vim.fn.findfile('prettier.config.js', '.;') ~= '' or
            vim.fn.findfile('package.json', '.;') ~= ''

        if prettier_config and vim.fn.executable('prettier') == 1 then
            -- Don't format here - let it save first, then format on BufWritePost
            return
        end
    end

    -- Fallback to LSP formatting
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then return end

    -- Ultra-fast formatting with reduced timeout
    local timeout_ms = 1000 -- Reduced to 1 second for speed

    pcall(function()
        vim.lsp.buf.format({
            async = false,
            timeout_ms = timeout_ms,
            bufnr = bufnr,
            filter = function(client)
                -- Quick filter for performance
                return client.name == "ruff" or
                    client.server_capabilities.documentFormattingProvider
            end
        })
    end)
end

autocmd("BufWritePre", {
    group = 'AutoTrim',
    pattern = "*",
    callback = function()
        -- Skip all operations for large files
        if vim.b.large_file then return end

        -- Always fast operations
        ensure_lf_line_endings()

        -- Conditional fast operations
        if not is_file_too_large() then
            trim_trailing_whitespace()
            ensure_single_trailing_newline()
        end

        -- Format with built-in checks
        format_file()
    end
})

autocmd("BufWritePost", {
    group = 'AutoTrim',
    pattern = "*.{js,jsx,ts,tsx,json,css,html}",
    callback = function()
        -- Skip for large files
        if vim.b.large_file or is_file_too_large() then return end

        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype

        -- Only run on JS/TS files
        if filetype == "javascript" or filetype == "typescript" or
            filetype == "javascriptreact" or filetype == "typescriptreact" or
            filetype == "json" or filetype == "css" or filetype == "html" then
            -- Check if prettier is available and there's a config file
            local prettier_config = vim.fn.findfile('.prettierrc', '.;') ~= '' or
                vim.fn.findfile('.prettierrc.json', '.;') ~= '' or
                vim.fn.findfile('.prettierrc.js', '.;') ~= '' or
                vim.fn.findfile('prettier.config.js', '.;') ~= '' or
                vim.fn.findfile('package.json', '.;') ~= ''

            if prettier_config and vim.fn.executable('prettier') == 1 then
                local filename = vim.fn.expand('%:p')
                if filename ~= '' then
                    pcall(function()
                        vim.cmd('silent !prettier --write ' .. vim.fn.shellescape(filename))
                        -- Reload the buffer to show formatted changes
                        vim.cmd('checktime')
                    end)
                end
            end
        end
    end
})

autocmd("BufNewFile", {
    group = 'AutoTrim',
    pattern = "*",
    callback = function()
        vim.bo.fileformat = 'unix'
    end
})
