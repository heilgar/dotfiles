return {
    "numToStr/Comment.nvim",
    config = function()
        require('Comment').setup({
            -- Disable default keymaps to avoid conflicts
            mappings = {
                basic = false,
                extra = false,
            },
        })

        -- Add custom keybindings
        vim.keymap.set('n', '<leader>/', function()
            require('Comment.api').toggle.linewise.current()
        end, { desc = 'Toggle comment on current line' })

        vim.keymap.set('v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
            { desc = 'Toggle comment on selected lines' })
    end
}

