return {
    'nvim-tree/nvim-web-devicons',
    lazy = true, -- Only load when required by other plugins
    config = function()
        require('nvim-web-devicons').setup({
            override = {},
            default = true,
        })
    end
}

