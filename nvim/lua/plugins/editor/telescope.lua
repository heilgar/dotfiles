-- NOTE: For better performance, install fd: brew install fd
-- This will improve file finding capabilities in Telescope

return {
    {
        'nvim-telescope/telescope-file-browser.nvim',
        keys = {
            { "<leader>fE", function()
                require('telescope').extensions.file_browser.file_browser({
                    grouped = true,
                    hidden = true,
                    respect_gitignore = false,
                    initial_mode = 'normal',
                    hijack_netrw = true,
                })
            end, desc = "File browser (Telescope)" },
        },
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    'nvim-telescope/telescope-ui-select.nvim',
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = { "Telescope" },
        keys = {
            -- File pickers (restored original behavior)
            { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope git_status<cr>",  desc = "Git changed files" }, -- RESTORED
            { "<C-p>",      "<cmd>Telescope git_files<cr>",   desc = "Git files" },         -- RESTORED
            { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Find buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",    desc = "Commands" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",     desc = "Keymaps" },
            { "<leader>fp", "<cmd>Telescope projects<cr>",    desc = "Projects" }, -- RESTORED

            -- Search pickers (moved live_grep to different key)
            { "<leader>sg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },                -- MOVED to sg
            { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" }, -- RESTORED
            {
                "<leader>ss",
                function()
                    local search_term = vim.fn.input("Search Term: ")
                    if search_term ~= "" then
                        require('telescope.builtin').grep_string({ search = search_term, use_regex = true })
                    end
                end,
                desc = "Search with input"
            }, -- RESTORED

            -- Git pickers
            { "<leader>gc", "<cmd>Telescope git_commits<cr>",           desc = "Git commits" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>",          desc = "Git branches" },

            -- LSP pickers (restored original keys)
            { "<leader>fD", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document symbols" },     -- RESTORED
            { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },    -- RESTORED
            { "jr",         "<cmd>Telescope lsp_references<cr>",        desc = "LSP references" },       -- RESTORED
            { "gi",         "<cmd>Telescope lsp_implementations<cr>",   desc = "LSP implementations" },  -- RESTORED
            { "jt",         "<cmd>Telescope lsp_type_definitions<cr>",  desc = "LSP type definitions" }, -- RESTORED

            -- Visual mode search (restored)
            {
                "<leader>sv",
                function()
                    vim.cmd('noau normal! "vy"')
                    local search_term = vim.fn.getreg('v'):gsub("\n", "")
                    require('telescope.builtin').grep_string({ search = search_term, use_regex = true })
                end,
                mode = "v",
                desc = "Search visual selection"
            }, -- RESTORED

            -- Other useful pickers
            { "<leader>tc", "<cmd>Telescope commands<cr>", desc = "Commands" }, -- RESTORED
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-dap.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "ahmedkhalf/project.nvim",
        },
        config = function()
            local telescope = require('telescope')
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local Path = require('plenary.path')

            -- Configure project.nvim
            require("project_nvim").setup({
                -- Detection methods
                detection_methods = { "lsp", "pattern" },

                -- Patterns used to detect project root
                patterns = {
                    ".git",
                    "package.json",
                    "pyproject.toml",
                    "requirements.txt",
                    "setup.py",
                    "Cargo.toml",
                    "composer.json",
                    "Gemfile",
                    "Makefile",
                    "CMakeLists.txt",
                    ".env",
                    ".env.json",
                },

                -- Don't show hidden files
                show_hidden = false,

                -- Don't search in these directories
                exclude_dirs = {
                    "~/.cache",
                    "~/.config",
                    "~/.local",
                    "~/.vim",
                    "~/.nvim",
                    "node_modules",
                    ".git",
                },

                -- Don't search for projects in these directories
                scope_chdir = "global",

                -- Automatically change directory when entering a project
                chdir = false,

                manual_mode = true,
            })

            local function open_file_and_jump_to_change(prompt_bufnr)
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)
                if selection then
                    vim.cmd('edit ' .. selection.path)
                    local diff = vim.fn.systemlist('git diff --unified=0 ' .. selection.path)
                    local first_change_line
                    for _, line in ipairs(diff) do
                        if line:match('^@@') then
                            first_change_line = tonumber(line:match('%%(%d+)'))
                            break
                        end
                    end
                    if first_change_line then
                        vim.api.nvim_win_set_cursor(0, { first_change_line, 0 })
                        vim.cmd('normal! zz')
                    end
                end
            end

            -- Function to open file in horizontal split
            local function open_in_hsplit(prompt_bufnr)
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)
                if selection then
                    vim.cmd('split ' .. selection.path)
                end
            end

            -- Function to open file in vertical split
            local function open_in_vsplit(prompt_bufnr)
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)
                if selection then
                    vim.cmd('vsplit ' .. selection.path)
                end
            end

            -- Function to open file in new tab
            local function open_in_tab(prompt_bufnr)
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)
                if selection then
                    vim.cmd('tabnew ' .. selection.path)
                end
            end


            -- Configure Telescope
            telescope.setup({
                defaults = {
                    cwd = vim.fn.getcwd(),
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--hidden',
                        '--glob', '!.git/*',
                        '--glob', '!node_modules/*',
                        '--glob', '!dist/*',
                    },
                    file_ignore_patterns = {
                        "node_modules/.*",
                        ".git/.*",
                        "dist/.*",
                        "build/.*",
                        "%.lock",
                        "package%-lock%.json",
                    },
                    layout_config = {
                        prompt_position = "top",
                        horizontal = {
                            width = 0.9,
                            height = 0.8,
                        },
                    },
                    sorting_strategy = "ascending",
                    mappings = {
                        i = {
                            -- Open in horizontal split
                            ["<C-s>"] = open_in_hsplit,
                            -- Open in vertical split
                            ["<C-v>"] = open_in_vsplit,
                            -- Open in new tab
                            ["<C-t>"] = open_in_tab,
                        },
                        n = {
                            -- Open in horizontal split
                            ["<C-s>"] = open_in_hsplit,
                            -- Open in vertical split
                            ["<C-v>"] = open_in_vsplit,
                            -- Open in new tab
                            ["<C-t>"] = open_in_tab,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*", "--glob", "!dist/*" },
                    },
                    git_status = {
                        attach_mappings = function(_, map)
                            map('i', '<CR>', open_file_and_jump_to_change)
                            map('n', '<CR>', open_file_and_jump_to_change)
                            return true
                        end
                    },
                    buffers = {
                        show_all_buffers = true,
                        sort_lastused = true,
                        mappings = {
                            i = {
                                ["<c-d>"] = "delete_buffer",
                            }
                        }
                    },
                },
            })

            -- Load Telescope extensions (only when telescope loads)
            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")
            telescope.load_extension("projects")
        end
    },
}
