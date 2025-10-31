return {
    {
        "heilgar/nvim-http-client",
        dir = "~/projects/plugins/nvim-http-client",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        event = "VeryLazy",
        ft = { "http", "rest" },
        keys = {
            { "<leader>he", "<cmd>HttpEnvFile<cr>",                          desc = "Select HTTP environment file" },
            { "<leader>hs", "<cmd>HttpSaveResponse<cr>",                     desc = "Save HttpResponse to file" },
            { "<leader>hr", "<cmd>HttpRun<cr>",                              desc = "Run HTTP request" },
            { "<leader>hx", "<cmd>HttpStop<cr>",                             desc = "Stop HTTP request" },
            { "<leader>hd", "<cmd>HttpDryRun<cr>",                           desc = "DryRun HTTP request" },
            { "<leader>hv", "<cmd>HttpVerbose<cr>",                          desc = "Toggle verbose for HTTP request" },
            { "<leader>ha", function() vim.cmd("HttpRunAll") end,            desc = "Run all HTTP requests" },
            { "<leader>hf", "<cmd>Telescope http_client http_env_files<cr>", desc = "Select HTTP env file (Telescope)" },
            { "<leader>hh", "<cmd>Telescope http_client http_envs<cr>",      desc = "Select HTTP env (Telescope)" },
            { "<leader>hp", "<cmd>HttpProfiling<cr>",                        desc = "Toggle HttpProfiling request profiling" },
            { "<leader>hc", "<cmd>HttpCopyCurl<cr>",                         desc = "Copy curl command for HTTP request" },
            { "<leader>hg", "<cmd>HttpSetProjectRoot<cr>",                   desc = "Set root" },
            { "<leader>hG", "<cmd>HttpGetProjectRoot<cr>",                   desc = "Get root" },
        },
        cmd = {
            "HttpEnvFile",
            "HttpEnv",
            "HttpRun",
            "HttpRunAll",
            "HttpStop",
            "HttpVerbose",
            "HttpDryRun",
            "HttpProfiling",
            "HttpCopyCurl",
            "HttpSaveResponse",
            "HttpSetProjectRoot",
            "HttpGetProjectRoot"
        },

        config = function()
            local http_client = require("http_client")
            http_client.setup({
                -- Keep custom keybindings disabled as per your preference
                create_keybindings = false,

                -- Request timeout in milliseconds
                request_timeout = 30000, -- 30 seconds

                -- Split direction for response window
                split_direction = "right",

                -- Profiling configuration
                profiling = {
                    enabled = true,
                    show_in_response = true,
                    detailed_metrics = true,
                }
            })

            -- Set up Telescope integration
            if pcall(require, "telescope") then
                require("telescope").load_extension("http_client")
            end

            -- Configure nvim-cmp for HTTP files with error handling
            if pcall(require, "cmp") then
                local ok, _ = pcall(function()
                    local cmp = require("cmp")
                    cmp.setup.filetype({ "http", "rest" }, {
                        sources = cmp.config.sources({
                            { name = "buffer" },       -- Buffer text for general completions
                        })
                    })
                end)

                if not ok then
                    vim.notify("Warning: HTTP filetype completion setup failed", vim.log.levels.WARN)
                end
            end
        end,
    },
    {
        "heilgar/bookmarks.nvim",
        dir = "~/projects/plugins/bookmarks.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('bookmarks').setup({
                use_branch_specific = true, -- Enable/disable branch-specific bookmarks
                auto_switch_branch = true,  -- Auto-reload bookmarks on branch switch
                default_scope = "global",   -- "global", "branch"
                default_list = "main",      -- Default list name
            })
            require('telescope').load_extension('bookmarks')
        end
    },
    {
        "grafana/vim-alloy",
        dir = "~/projects/plugins/vim-alloy",
        ft = "alloy",
    },
    -- {
    --     "heilgar/nochat.nvim",
    --     dir = "~/plugins/nochat.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --     },
    --     config = function()
    --         local nochat = require('nochat')
    --
    --         -- Only define providers you want to enable
    --         local config = {
    --             api_keys = {
    --                 anthropic = 'api-key',
    --                 openai = 'api-key',
    --             },
    --             providers = {
    --                 -- Comment out or remove providers you don't want
    --                 anthropic = {
    --                     models = {
    --                         'claude-3-opus-20240229',
    --                         'claude-3-sonnet-20240229',
    --                         'claude-3-haiku-20240307',
    --                     },
    --
    --                     api_key = 'api-key'
    --                 },
    --                 -- openai = {
    --                 --     models = {
    --                 --         'gpt-4-turbo',
    --                 --         'gpt-4',
    --                 --         'gpt-3.5-turbo',
    --                 --     },
    --                 --     api_key = 'api_key'
    --                 -- },
    --                 ollama = {
    --                     host = 'http://localhost:11434'
    --                 }
    --             }
    --         }
    --
    --         nochat.setup(config)
    --     end,
    -- }
}

