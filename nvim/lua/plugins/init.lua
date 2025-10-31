return {
    -- UI
    require('plugins.ui.colorscheme'),
    require('plugins.ui.lualine'),
    require('plugins.ui.noice'),
    require('plugins.ui.devicons'),

    -- Tools
    require('plugins.tools.git'),
    require('plugins.tools.plenary'),
    require('plugins.tools.neoclip'),
    require('plugins.tools.trouble'),
    require('plugins.tools.ai'),
    require('plugins.tools.osc52'),
    require('plugins.tools.dap'),
    require('plugins.tools.lsp'),


    -- Editor enhancements
    require('plugins.editor.completion'),
    require('plugins.editor.treesitter'),
    require('plugins.editor.telescope'),
    require('plugins.editor.nvim-tree'),
    require('plugins.editor.harpoon'),
    require('plugins.editor.undotree'),
    require('plugins.editor.comment'),
    require('plugins.editor.autopairs'),
    require('plugins.editor.which-key'),
    require('plugins.editor.editorconfig'),
    require('plugins.editor.heilgar'),
}
