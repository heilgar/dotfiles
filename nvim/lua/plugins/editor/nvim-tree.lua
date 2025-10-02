return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local function highlight_test_files()
            vim.cmd([[
        highlight NvimTreeTestFile guibg=#1a3d1a50 guifg=NONE
        highlight NvimTreeTestFolder guibg=#1a3d1a50 guifg=NONE gui=bold

        " Match files containing 'test' or 'Test' anywhere in the name, including those with multiple dots
        syntax match NvimTreeTestFile /\v.*[tT]est.*(\.([-A-Za-z0-9.]+))?$/ containedin=NvimTreeNormal

        " Match folders containing 'test' or 'Test' in the name
        syntax match NvimTreeTestFolder /\v.*[tT]est.*\// containedin=NvimTreeNormal

        " Highlight special test file names (e.g., test_*.py, *_test.go)
        syntax match NvimTreeTestFile /\vtest_.*\.[^/]+$/ containedin=NvimTreeNormal
        syntax match NvimTreeTestFile /\v.*_test\.[^/]+$/ containedin=NvimTreeNormal
    ]])
        end

        local function create_file()
            local api = require("nvim-tree.api")
            local node = api.tree.get_node_under_cursor()
            local path = node.absolute_path
            if node.type == "directory" then
                path = path .. "/"
            else
                path = vim.fn.fnamemodify(path, ":h") .. "/"
            end

            local input = vim.fn.input("Create file: " .. path, "", "file")
            if input ~= "" then
                local full_path = path .. input
                vim.fn.system("touch " .. vim.fn.shellescape(full_path))
                api.tree.reload()
            end
        end


        local function on_attach(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            -- Default mappings
            api.config.mappings.default_on_attach(bufnr)
            -- Custom mappings
            vim.keymap.set('n', '%', create_file, opts('Create File'))

            highlight_test_files()
        end


        require("nvim-tree").setup({
            on_attach = on_attach,
            sync_root_with_cwd = false,
            respect_buf_cwd = false,
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
            renderer = {
                highlight_git = true,
                icons = {
                    show = {
                        git = true,
                    },
                },
            },
            view = {
                width = 30,
                side = "left",
                float = {
                    enable = true,
                    open_win_config = function()
                        local ui = vim.api.nvim_list_uis()[1] or {}
                        local total_width = ui.width or vim.o.columns
                        local total_height = (ui.height or vim.o.lines) - vim.o.cmdheight

                        -- Desired size (clamped to safe bounds)
                        local desired_width = math.floor(total_width * 0.6)
                        local desired_height = math.floor(total_height * 0.7)

                        local width = math.min(math.max(desired_width, 40), total_width - 4)
                        local height = math.min(math.max(desired_height, 10), total_height - 2)

                        local row = math.max(math.floor((total_height - height) / 2), 0)
                        local col = math.max(math.floor((total_width - width) / 2), 0)

                        return {
                            relative = 'editor',
                            border = 'rounded',
                            width = width,
                            height = height,
                            row = row,
                            col = col,
                        }
                    end,
                },
            },
            actions = {
                open_file = {
                    quit_on_open = false,
                },
            },
            filters = {
                dotfiles = false, -- Show dotfiles
                exclude = {       -- Files to never hide
                    ".gitignore",
                    ".env",
                    "git.lua",
                    ".github",
                },
                custom = {
                    "node_modules",
                    "dist",
                    ".git",
                    "build",
                    ".next",
                }
            }

        })

        vim.keymap.set('n', '<leader>fe', ':NvimTreeToggle<CR>',
            { noremap = true, silent = true, desc = 'Toggle file explorer' })
    end,
}
