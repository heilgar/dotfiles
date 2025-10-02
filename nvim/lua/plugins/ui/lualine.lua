return {
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy", -- Lazy load the statusline
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = "jellybeans",
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = {
                        {
                            'filename',
                            path = 1
                        }
                    },
                    lualine_x = {
                        {
                            'bookmarks',
                            function()
                                return require('bookmarks').status_short()
                            end,
                            color = { fg = '#FFE5B4' },
                            separator = { left = ' ', right = '' },
                        },
                        {
                            'diagnostics',
                            sources = { 'nvim_diagnostic', 'nvim_lsp' },
                            sections = { 'error', 'warn', 'info', 'hint' },
                            diagnostics_color = {
                                error = 'DiagnosticError',
                                warn  = 'DiagnosticWarn',
                                info  = 'DiagnosticInfo',
                                hint  = 'DiagnosticHint',
                            },
                            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
                            colored = true,
                            update_in_insert = false,
                            always_visible = false,
                        },
                        'encoding',
                        'fileformat',
                        'filetype'
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        'filename',

                    },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            })
        end

    }
}
