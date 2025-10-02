return {
    {
        "folke/trouble.nvim",
        opts = {
            modes = {
                diagnostics = {
                    auto_open = false,
                    auto_close = false,
                    auto_preview = true,
                    auto_refresh = true,
                    focus = false,
                    restore = true,
                    follow = true,
                    indent_guides = true,
                    max_items = 200,
                    multiline = true,
                    pinned = false,
                    warn_no_results = true,
                    open_no_results = false,
                    win = { position = "bottom", size = 0.3 },
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.3,
                    },
                    keys = {
                        ["?"] = "help",
                        r = "refresh",
                        R = "toggle_refresh",
                        q = "close",
                        o = "jump_close",
                        ["<esc>"] = "cancel",
                        ["<cr>"] = "jump",
                        ["<2-leftmouse>"] = "jump",
                        ["<c-s>"] = "jump_split",
                        ["<c-v>"] = "jump_vsplit",
                        -- Toggle between project and buffer diagnostics
                        ["<c-t>"] = "toggle_mode",
                        -- Focus preview window
                        ["<c-p>"] = "toggle_preview",
                        P = "toggle_preview",
                        -- Fold/unfold
                        ["zM"] = "fold_close_all",
                        ["zR"] = "fold_open_all",
                        ["zm"] = "fold_close",
                        ["zr"] = "fold_open",
                        ["za"] = "fold_toggle",
                        ["zA"] = "fold_toggle_all",
                        -- Filter by severity
                        ["1"] = { action = "filter", filter = { severity = vim.diagnostic.severity.ERROR } },
                        ["2"] = { action = "filter", filter = { severity = vim.diagnostic.severity.WARN } },
                        ["3"] = { action = "filter", filter = { severity = vim.diagnostic.severity.INFO } },
                        ["4"] = { action = "filter", filter = { severity = vim.diagnostic.severity.HINT } },
                        ["0"] = { action = "filter", filter = {} },
                    },
                },
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        config = function(_, opts)
            require("trouble").setup(opts)

            -- Remove the noice util override as it might interfere with error display
            -- local noice_util = require("noice.util")
            -- noice_util.open = function(_) end
            -- noice_util.close = function(_) end
        end,
    }
}

