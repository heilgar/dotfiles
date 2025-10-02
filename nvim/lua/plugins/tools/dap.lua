return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require('dap')
            
            -- Configure virtual text (with error handling)
            local virtual_text_success, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
            if virtual_text_success then
                dap_virtual_text.setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                virt_text_pos = 'eol',
                all_frames = true,
                virt_lines = false,
                                    virt_text_win_col = nil
                })
            else
                vim.notify("Failed to load nvim-dap-virtual-text", vim.log.levels.WARN)
            end

            -- Configure DAP UI (with error handling)
            local dapui_success, dapui = pcall(require, 'dapui')
            if dapui_success then
                dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                element_mappings = {},
                expand_lines = true,
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.33 },
                            { id = "breakpoints", size = 0.17 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 0.33,
                        position = "right",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.45 },
                            { id = "console", size = 0.55 },
                        },
                        size = 0.27,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "↻",
                        terminate = "□",
                    },
                },
                floating = {
                    max_height = 0.9,
                    max_width = 0.5,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil,
                    max_value_lines = 100,
                },
            })
            else
                vim.notify("Failed to load dapui", vim.log.levels.WARN)
            end

            -- Python DAP configuration with uv support
            local function setup_python_adapter()
                -- Check if uv is available
                local uv_available = vim.fn.executable('uv') == 1
                
                if uv_available then
                    dap.adapters.python = {
                        type = 'executable';
                        command = 'uv';
                        args = { 'run', 'python', '-m', 'debugpy.adapter' };
                    }
                else
                    -- Fallback to regular python
                    dap.adapters.python = {
                        type = 'executable';
                        command = 'python';
                        args = { '-m', 'debugpy.adapter' };
                    }
                end
            end
            
            setup_python_adapter()

            -- Function to load workspace configurations
            local function load_workspace_configs()
                local workspace_root = vim.fn.getcwd()
                local config_files = {
                    workspace_root .. "/.vscode/launch.json",
                    workspace_root .. "/.nvim/launch.json",
                    workspace_root .. "/.dap/launch.json",
                    workspace_root .. "/launch.json",
                }
                
                for _, config_file in ipairs(config_files) do
                    local file = io.open(config_file, "r")
                    if file then
                        file:close()
                        local success, config = pcall(vim.fn.json_decode, vim.fn.readfile(config_file))
                        if success and config and config.configurations then
                            -- Process each configuration
                            for _, cfg in ipairs(config.configurations) do
                                -- Handle path mappings for workspace paths
                                if cfg.pathMappings then
                                    for _, mapping in ipairs(cfg.pathMappings) do
                                        -- Replace ${workspaceFolder} with actual workspace path
                                        if mapping.localRoot and mapping.localRoot:find("${workspaceFolder}") then
                                            mapping.localRoot = mapping.localRoot:gsub("${workspaceFolder}", workspace_root)
                                        end
                                        if mapping.remoteRoot and mapping.remoteRoot:find("${workspaceFolder}") then
                                            mapping.remoteRoot = mapping.remoteRoot:gsub("${workspaceFolder}", workspace_root)
                                        end
                                    end
                                end
                                
                                -- Add configuration to DAP
                                if cfg.type == "python" then
                                    if not dap.configurations.python then
                                        dap.configurations.python = {}
                                    end
                                    table.insert(dap.configurations.python, cfg)
                                end
                            end
                            vim.notify("Loaded DAP configurations from: " .. config_file, vim.log.levels.INFO)
                            return true
                        end
                    end
                end
                -- Don't show error if no config files found - this is normal
                return false
            end

            -- Load workspace configurations on startup
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    load_workspace_configs()
                end,
            })

            -- Auto open/close DAP UI (only if dapui is available)
            if dapui_success then
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end

            -- Create user command to reload workspace configurations
            vim.api.nvim_create_user_command('DapLoadConfigs', function()
                load_workspace_configs()
            end, { desc = 'Reload DAP configurations from workspace files' })

            -- Create user command to show current configurations
            vim.api.nvim_create_user_command('DapShowConfigs', function()
                local configs = dap.configurations.python or {}
                print("Current Python DAP configurations:")
                for i, config in ipairs(configs) do
                    print(string.format("  %d. %s", i, config.name or "Unnamed"))
                end
            end, { desc = 'Show current DAP configurations' })

            -- Create user command to install debugpy
            vim.api.nvim_create_user_command('DapInstallDebugpy', function()
                local uv_available = vim.fn.executable('uv') == 1
                if uv_available then
                    vim.notify("Installing debugpy with uv...", vim.log.levels.INFO)
                    vim.cmd("!uv add debugpy")
                else
                    vim.notify("uv not found. Please install debugpy manually: pip install debugpy", vim.log.levels.WARN)
                end
            end, { desc = 'Install debugpy for DAP debugging' })

            -- Load telescope-dap extension after a short delay to ensure telescope is ready
            vim.defer_fn(function()
                local telescope_available, telescope = pcall(require, 'telescope')
                if telescope_available then
                    local success, _ = pcall(telescope.load_extension, 'dap')
                    if not success then
                        vim.notify("Failed to load telescope-dap extension", vim.log.levels.WARN)
                    end
                else
                    vim.notify("Telescope not available for DAP extension", vim.log.levels.WARN)
                end
            end, 100)
        end,
    },
} 