return {
    {
        'tpope/vim-fugitive',
        cmd = { "Git", "G", "Gstatus", "Gblame", "Gpush", "Gpull" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>",       desc = "Git status" },
            { "<leader>gB", "<cmd>Git blame<CR>", desc = "Git blame" },
            { "<leader>gp", "<cmd>Git push<CR>",  desc = "Git push" },
            { "<leader>gl", "<cmd>Git pull<CR>",  desc = "Git pull" },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
        cond = function()
            -- Only load if we're in a git repository
            return vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true") ~= nil
        end,
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '│' },
                    change = { text = '│' },
                    delete = { text = '󰍵' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked = { text = '┆' },
                },
                current_line_blame = false, -- Disable by default for performance
                current_line_blame_opts = {
                    delay = 1000,           -- Increase delay to reduce updates
                },
                update_debounce = 200,      -- Increase debounce for better performance
            })
        end
    },
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>",                   desc = "Open diff view" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<CR>",            desc = "File history" },
            { "<leader>gD", function() _G.open_diff_with_branch() end, desc = "Diff with branch" },
            { "<leader>gq", "<cmd>DiffviewClose<CR>",                  desc = "Close diff view" },
        },
        config = function()
            local diffview = require('diffview')
            diffview.setup({
                diff_binaries = false,    -- Don't show diffs for binaries
                enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
                git_cmd = { "git" },      -- The git executable followed by default args.
                use_icons = true,         -- Requires nvim-web-devicons
            })

            _G.open_diff_with_branch = function()
                -- Get all branches, including remotes, with full names
                local branches = vim.fn.systemlist('git branch --all --format="%(refname)"')

                -- Process branch names for display
                local display_branches = {}
                for _, branch in ipairs(branches) do
                    -- Remove 'refs/heads/' from local branches and 'refs/remotes/' from remote branches
                    local display_name = branch:gsub('^refs/heads/', ''):gsub('^refs/remotes/', '')
                    table.insert(display_branches, display_name)
                end

                vim.schedule(function()
                    require('telescope.pickers').new({}, {
                        prompt_title = 'Select Branch for Diff',
                        finder = require('telescope.finders').new_table {
                            results = display_branches
                        },
                        sorter = require('telescope.config').values.generic_sorter({}),
                        attach_mappings = function(prompt_bufnr, map)
                            local actions = require('telescope.actions')
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local selection = require('telescope.actions.state').get_selected_entry()
                                -- Use the selected branch name directly
                                local branch = selection[1]
                                vim.cmd('DiffviewOpen ' .. vim.fn.shellescape(branch))
                            end)
                            return true
                        end,
                    }):find()
                end)
            end
        end
    }
}
