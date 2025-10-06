local opt = vim.opt

-- UI enhancements
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true

opt.splitright = true -- Ctrl+w v
opt.splitbelow = true -- Ctrl+w s

-- Enable mouse support
opt.mouse = 'a'

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Better completion experience
opt.completeopt = { 'menuone', 'noselect' }

-- Performance optimizations
opt.updatetime = 100
opt.timeoutlen = 200 -- Fast key combinations
opt.ttimeoutlen = 5  -- Lightning-fast escape sequences

opt.lazyredraw = false
opt.ttyfast = true        -- Fast terminal connection
opt.regexpengine = 1      -- Use old regex engine (faster for most cases)

opt.scrolloff = 8         -- Keep cursor centered
opt.sidescrolloff = 8     -- Horizontal scrolling margin
opt.scroll = 10           -- Lines to scroll with Ctrl-D/U

opt.maxmempattern = 1000  -- Limit memory for pattern matching
opt.history = 1000
opt.hidden = true         -- Keep buffers in memory
opt.shortmess:append("c") -- Don't show completion messages
opt.shortmess:append("I") -- Don't show intro message

opt.writebackup = true
opt.autowrite = false
opt.autoread = true   -- Auto-reload changed files
opt.autochdir = false -- Don't automatically change directory to file's directory

-- Backup (using undotree)
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.synmaxcol = 500   -- Reduced from 1000 for speed
opt.redrawtime = 1500 -- Max time for syntax highlighting

-- Performance: Reduce some visual features for large files
vim.g.large_file = 2048 * 1024 -- Reduced to 2M

if vim.loop.os_uname().sysname == "Darwin" then
    vim.g.osc52 = false

    vim.g.clipboard = {
        name = 'pbcopy/pbpaste',
        copy = {
            ['+'] = 'pbcopy',
            ['*'] = 'pbcopy',
        },
        paste = {
            ['+'] = 'pbpaste',
            ['*'] = 'pbpaste',
        },
    }
end


-- Minimal centering events for maximum speed
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        if vim.bo.buftype == "" then
            -- Use schedule to avoid blocking
            vim.schedule(function()
                pcall(function() vim.cmd("normal! zz") end)
            end)
        end
    end,
    desc = "Center cursor after opening files"
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
    callback = function()
        if vim.bo.buftype == "" then
            vim.wo.number = true
            vim.wo.relativenumber = true
        end
    end
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
        local line_count = vim.fn.line('$')

        -- More aggressive thresholds for blazing speed
        if file_size > vim.g.large_file or line_count > 2000 then
            vim.notify("Optimizing for large file - maximum speed mode!", vim.log.levels.INFO)

            -- Disable expensive features
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.opt_local.wrap = false
            vim.opt_local.swapfile = false
            vim.opt_local.undofile = false
            vim.opt_local.cursorline = false
            vim.opt_local.relativenumber = false
            vim.opt_local.number = true -- Keep absolute numbers only

            -- Disable syntax for maximum speed
            vim.cmd("syntax off")
            vim.cmd("set nohlsearch")

            -- Disable some LSP features for speed
            vim.b.large_file = true
        end
    end
})

vim.g.terminal_scrollback_buffer_size = 1000 -- Reduce terminal buffer

vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
