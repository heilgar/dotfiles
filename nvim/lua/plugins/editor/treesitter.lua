return {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
   
                ensure_installed = {
                    -- Core essentials
                    "lua", "vim", "vimdoc", "query",
                    -- Common languages (add only what you need)
                    "javascript", "typescript", "tsx", "jsdoc",
                    "python",
                    "markdown", "markdown_inline",
                    "json", "yaml",
                    -- Add others only when needed
                    "c", "cmake", "php", "sql", "terraform", 
                    "regex", "bash",
                },
    
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,
    
                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
                auto_install = true,
    
                indent = {
                    enable = true
                },
    
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
    
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = { "markdown" },
                },
            })
    
            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = {"src/parser.c", "src/scanner.c"},
                    branch = "master",
                },
            }
    
            vim.treesitter.language.register("templ", "templ")
            
            -- Fix for "Invalid 'end_col': out of range" error
            -- This patches the highlighter to handle invalid column positions gracefully
            local original_set_extmark = vim.api.nvim_buf_set_extmark
            vim.api.nvim_buf_set_extmark = function(bufnr, ns_id, line, col, opts)
                -- Validate column positions before setting extmark
                if opts and opts.end_col then
                    local line_count = vim.api.nvim_buf_line_count(bufnr)
                    if line >= line_count then
                        return 0 -- Return invalid mark ID
                    end
                    
                    local line_content = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ""
                    local max_col = #line_content
                    
                    -- Ensure end_col doesn't exceed line length
                    if opts.end_col > max_col then
                        opts.end_col = max_col
                    end
                    
                    -- Ensure start col doesn't exceed line length
                    if col > max_col then
                        col = max_col
                    end
                end
                
                -- Call original function with safe parameters
                return original_set_extmark(bufnr, ns_id, line, col, opts)
            end
            
            -- Configure treesitter-context
            require("treesitter-context").setup({
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
        end
   }

