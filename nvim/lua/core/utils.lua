local M = {}

M.organize_imports = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    
    if filetype == "python" then
        -- Use Ruff for Python import organization
        local ruff_client = nil
        for _, client in ipairs(clients) do
            if client.name == "ruff" then
                ruff_client = client
                break
            end
        end
        
        if ruff_client then
            local success = pcall(function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                })
            end)
            
            if not success then
                vim.notify("Could not organize Python imports with Ruff", vim.log.levels.DEBUG)
            end
        else
            vim.notify("Ruff LSP not available for import organization", vim.log.levels.DEBUG)
        end
    else
        -- Use TypeScript LSP for JavaScript/TypeScript files
        local ts_client = nil
        for _, client in ipairs(clients) do
            if client.name == "ts_ls" or client.name == "typescript-language-server" then
                ts_client = client
                break
            end
        end
        
        if ts_client then
            local timeout_ms = 2000 -- 2 second timeout
            local success = pcall(function()
                vim.lsp.buf.execute_command({
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) }
                })
            end)
            
            if not success then
                vim.notify("Could not organize imports", vim.log.levels.DEBUG)
            end
        else
            -- Fallback: try generic organize imports code action
            local success = pcall(function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                })
            end)
            
            if not success then
                vim.notify("No LSP client available for import organization", vim.log.levels.DEBUG)
            end
        end
    end
end

-- Open documentation for symbol under cursor, language-aware
function M.open_docs_for_symbol()
    local filetype = vim.bo.filetype
    local word = vim.fn.expand("<cword>")
    if filetype == "c" or filetype == "cpp" then
        -- Open a new tab, then use Telescope man_pages for C/C++
        local ok, telescope_builtin = pcall(require, 'telescope.builtin')
        if ok and telescope_builtin.man_pages then
            if word and word ~= "" then
                telescope_builtin.man_pages({ default_text = word, sections = { "1", "2", "3" } })
            else
                telescope_builtin.man_pages({ sections = { "1", "2", "3" } })
            end
        else
            vim.notify("Telescope man_pages not available", vim.log.levels.ERROR)
        end
        return
    end
    if not word or word == "" then
        -- For other filetypes, open Telescope man_pages picker if no symbol
        local ok, telescope_builtin = pcall(require, 'telescope.builtin')
        if ok and telescope_builtin.man_pages then
            telescope_builtin.man_pages()
        else
            vim.notify("Telescope man_pages not available", vim.log.levels.ERROR)
        end
        return
    end
    if filetype == "python" then
        if vim.fn.exists(":Pydoc") == 2 then
            vim.cmd("tabnew | Pydoc " .. word)
        else
            vim.cmd("tabnew | terminal python3 -c 'help(\'" .. word .. "\')'")
            vim.cmd("startinsert")
        end
    elseif filetype == "go" then
        if vim.fn.exists(":GoDoc") == 2 then
            vim.cmd("tabnew | GoDoc " .. word)
        else
            vim.lsp.buf.hover()
        end
    elseif filetype == "rust" then
        if vim.fn.exists(":RustOpenExternalDocs") == 2 then
            vim.cmd("tabnew | RustOpenExternalDocs " .. word)
        else
            vim.lsp.buf.hover()
        end
    else
        -- Fallback: try LSP hover in a new tab
        vim.cmd("tabnew")
        vim.lsp.buf.hover()
    end
end

-- Copy relative project path from current file
function M.copy_relative_path()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        vim.notify("No file is currently open", vim.log.levels.WARN)
        return
    end
    
    -- Get the current working directory
    local cwd = vim.fn.getcwd()
    
    -- Get the absolute path of the current file
    local absolute_path = vim.fn.fnamemodify(current_file, ":p")
    
    -- Calculate relative path from cwd to the file
    local relative_path = vim.fn.fnamemodify(absolute_path, ":.")
    
    -- If the file is not in the current working directory, try to get relative path
    if relative_path == absolute_path then
        -- File is not in cwd, try to get relative path from cwd
        relative_path = vim.fn.fnamemodify(absolute_path, ":~:.")
    end
    
    -- Get cursor position (line and column)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line = cursor_pos[1]
    local col = cursor_pos[2] + 1  -- Convert to 1-based column
    
    -- Format: path:line:col
    local path_with_position = string.format("%s:%d:%d", relative_path, line, col)
    
    -- Copy to clipboard using OSC52 if available, otherwise use system clipboard
    local ok, osc52 = pcall(require, 'osc52')
    if ok then
        osc52.copy(path_with_position)
        vim.notify('Copied relative path with position to clipboard: ' .. path_with_position, vim.log.levels.INFO)
    else
        -- Fallback to system clipboard
        vim.fn.setreg('+', path_with_position)
        vim.notify('Copied relative path with position to clipboard (fallback): ' .. path_with_position, vim.log.levels.INFO)
    end
end


return M

