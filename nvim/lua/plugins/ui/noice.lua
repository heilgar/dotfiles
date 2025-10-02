return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require('noice').setup({
            -- Enable messages to be captured in :messages
            messages = {
                enabled = true,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages", -- Show message history in :messages
                filter = { event = "msg_show", kind = "", any = true },
                filter_opts = { reverse = false },
                routes = {
                    {
                        filter = { event = "msg_show", kind = "search_count" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", kind = "wmsg" },
                        opts = { skip = true },
                    },
                },
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    enabled = true,
                    silent = false, -- set to true to not show a message if hover is not available
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                        throttle = 50, -- Debounce lsp signature help request by 50ms
                    },
                    view = nil, -- when nil, use defaults from documentation
                    opts = {}, -- merged with defaults from documentation
                },
                message = {
                    -- Messages shown by lsp servers
                    enabled = true,
                    view = "notify",
                    opts = {},
                },
                documentation = {
                    view = "hover",
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
        })
        require('notify').setup({
            top_down = false,
            background_colour = "#000000",
            -- Ensure notifications are also captured in message history
            render = "default",
            stages = "fade_in_slide_out",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        })
        
        -- Override vim.notify to also add messages to message history
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
            -- Call the original notify function
            original_notify(msg, level, opts)
            
            -- Also add to message history for :messages command
            if level == vim.log.levels.ERROR then
                vim.api.nvim_echo({{msg, "ErrorMsg"}}, true, {})
            elseif level == vim.log.levels.WARN then
                vim.api.nvim_echo({{msg, "WarningMsg"}}, true, {})
            elseif level == vim.log.levels.INFO then
                vim.api.nvim_echo({{msg, "MoreMsg"}}, true, {})
            else
                vim.api.nvim_echo({{msg, "Normal"}}, true, {})
            end
        end
    end
}

