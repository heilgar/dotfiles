return {
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    },
    {
        'windwp/nvim-ts-autotag',
        lazy = true,
        event = { "InsertEnter" },
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
        config = function()
            require('nvim-ts-autotag').setup()
        end
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
            vim.keymap.set("n", "<leader>rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true, desc = "LSP Rename with live preview" })
        end,
    }
}
