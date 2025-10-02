-- 🔥 BLAZING FAST LAZY.NVIM SETUP 🔥

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',        -- Faster clone
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- ⚡ ULTRA-FAST LAZY CONFIGURATION ⚡
require('lazy').setup('plugins', {
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",      -- Disable for speed
                -- "netrwPlugin",  -- Re-enabled for directory opening
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
        backdrop = 60,             -- Faster UI rendering
    },
    change_detection = {
        enabled = false,           -- Disable for faster startup
    },
    checker = {
        enabled = false,           -- Disable auto-checking for speed
    },
    install = {
        missing = false,           -- Don't auto-install missing plugins
    },
})

