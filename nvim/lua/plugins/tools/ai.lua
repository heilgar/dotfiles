return {
    {
        'github/copilot.vim',
        event = "InsertEnter",
        config = function()
            -- Disable default Tab mapping to avoid conflict with LSP completion
            vim.g.copilot_no_tab_map = true

            -- Set custom keymaps for Copilot
            vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                desc = 'Accept Copilot suggestion'
            })

            -- Additional Copilot controls
            vim.keymap.set('i', '<M-]>', 'copilot#Next()', { expr = true, desc = 'Next Copilot suggestion' })
            vim.keymap.set('i', '<M-[>', 'copilot#Previous()', { expr = true, desc = 'Previous Copilot suggestion' })
            vim.keymap.set('i', '<C-x>', 'copilot#Dismiss()', { expr = true, desc = 'Dismiss Copilot suggestion' })
        end,
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        cmd = {
            "ClaudeCode",
            "ClaudeCodeFocus",
            "ClaudeCodeSelectModel",
            "ClaudeCodeSend",
            "ClaudeCodeAdd",
            "ClaudeCodeDiffAccept",
            "ClaudeCodeDiffDeny",
            "ClaudeCodeStatus",
        },
        opts = {
            terminal_cmd = "~/.volta/bin/claude",
            diff = {
                replace_buffer = true,
                vertical = false,
            },
        },
        config = true,
        keys = {
            { "<leader>a",  nil,                              desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
        },
    }

}
