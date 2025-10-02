return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        
        -- Load friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()
        
        -- Configure completion
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = 'rounded',
                    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                }),
                documentation = cmp.config.window.bordered({
                    border = 'rounded',
                    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                }),
            },
            mapping = {
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp', priority = 1000 },
                { name = 'luasnip', priority = 750 },
                { name = 'buffer', priority = 500 },
                { name = 'path', priority = 250 },
            }),
            formatting = {
                format = function(entry, vim_item)
                    -- Kind icons
                    local kind_icons = {
                        Text = '󰉿',
                        Method = '󰆧',
                        Function = '󰊕',
                        Constructor = '󰆧',
                        Field = '󰜢',
                        Variable = '󰀫',
                        Class = '󰠱',
                        Interface = '󰠱',
                        Module = '󰏗',
                        Property = '󰜢',
                        Unit = '󰑭',
                        Value = '󰎠',
                        Enum = '󰒻',
                        Keyword = '󰌋',
                        Snippet = '󰃐',
                        Color = '󰏘',
                        File = '󰈙',
                        Reference = '󰈇',
                        Folder = '󰉋',
                        EnumMember = '󰒻',
                        Constant = '󰏿',
                        Struct = '󰙅',
                        Event = '󰎔',
                        Operator = '󰆕',
                        TypeParameter = '󰊄',
                    }
                    
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind)
                    
                    -- Source
                    vim_item.menu = ({
                        nvim_lsp = '[LSP]',
                        luasnip = '[Snippet]',
                        buffer = '[Buffer]',
                        path = '[Path]',
                    })[entry.source.name]
                    
                    return vim_item
                end,
            },
            experimental = {
                ghost_text = true,
            },
        })
        
        -- Set up cmdline completion with error handling
        local ok, _ = pcall(function()
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    { name = 'cmdline' },
                }),
            })
            
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
        end)
        
        if not ok then
            vim.notify("Warning: cmdline completion setup failed, continuing without it", vim.log.levels.WARN)
        end
    end,
} 