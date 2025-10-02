return {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide" },
    keys = {
        { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
    config = function()
        -- Enable persistent undo across sessions
        vim.g.undotree_PersistentUndo = 1
        
        -- Window layout and appearance
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_SplitWidth = 30
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_TreeNodeShape = '◉'
        vim.g.undotree_TreeVertShape = '│'
        vim.g.undotree_TreeSplitShape = '╱'
        vim.g.undotree_TreeReturnShape = '╲'
        
        -- Diff panel settings
        vim.g.undotree_DiffAutoOpen = 1
        vim.g.undotree_DiffpanelHeight = 10
        
        -- Display options
        vim.g.undotree_RelativeTimestamp = 1
        vim.g.undotree_HighlightChangedText = 1
        vim.g.undotree_HighlightChangedWithSign = 1
        vim.g.undotree_HighlightSyntaxAdd = "DiffAdd"
        vim.g.undotree_HighlightSyntaxChange = "DiffChange"
        vim.g.undotree_HighlightSyntaxDel = "DiffDelete"
    end
}

