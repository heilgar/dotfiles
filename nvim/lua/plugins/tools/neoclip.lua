return {
    "AckslD/nvim-neoclip.lua",
    keys = {
        { "<leader>fc", "<cmd>Telescope neoclip<cr>", desc = "Clipboard history" }, -- RESTORED original key
        { "<leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Yank history" }, -- Alternative key
        { "<leader>fq", "<cmd>Telescope neoclip plus<cr>", desc = "Yank history with system clipboard" },
    },
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "kkharji/sqlite.lua", -- Optional for persistent history
    },
    config = function()
        require('neoclip').setup({
            history = 1000,
            enable_persistent_history = true,
            length_limit = 1048576,
            continuous_sync = false,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            prompt = nil,
            default_register = '"',
            default_register_macros = 'q',
            enable_macro_history = true,
            content_spec_column = false,
            on_select = {
                move_to_front = false,
                close_telescope = true,
            },
            on_paste = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_replay = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_custom_action = {
                close_telescope = true,
            },
            keys = {
                telescope = {
                    i = {
                        select = '<cr>',
                        paste = '<c-p>',
                        paste_behind = '<c-k>',
                        replay = '<c-q>',
                        delete = '<c-d>',
                        edit = '<c-e>',
                        custom = {},
                    },
                    n = {
                        select = '<cr>',
                        paste = 'p',
                        paste_behind = 'P',
                        replay = 'q',
                        delete = 'd',
                        edit = 'e',
                        custom = {},
                    },
                },
            },
        })
        
        -- Load telescope extension only when neoclip loads
        require('telescope').load_extension('neoclip')
    end,
}

