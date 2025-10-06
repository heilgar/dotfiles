local utils = require('core.utils')

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local MAX_FILE_SIZE_FOR_FORMAT = 50 * 1024 -- Reduced to 50KB for speed
local MAX_LINES_FOR_HEAVY_OPS = 1000       -- Reduced to 1000 lines for speed

augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = 'YankHighlight',
    callback = function()
        -- Reduced timeout for faster visual feedback
        vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 })
    end
})

augroup('AutoTrim', { clear = true })

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

local function is_file_too_large()
    local line_count = vim.fn.line('$')
    if line_count > MAX_LINES_FOR_HEAVY_OPS then return true end

    local file_size = vim.fn.getfsize(vim.fn.expand('%:p'))
    return file_size > MAX_FILE_SIZE_FOR_FORMAT
end

local function format_file()
    if is_file_too_large() or vim.b.large_file then
        return
    end

    local ok, keymaps = pcall(require, 'lspconfig.keymaps')
    if ok and keymaps.smart_format then
        keymaps.smart_format()
    end
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

autocmd("BufNewFile", {
    group = 'AutoTrim',
    pattern = "*",
    callback = function()
        vim.bo.fileformat = 'unix'
    end
})
