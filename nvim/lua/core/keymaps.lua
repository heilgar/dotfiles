local utils = require('core.utils')

local map = vim.keymap.set

-- General Navigation
map('n', '<leader>e', function() vim.cmd("Ex") end, { desc = "Open file explorer" })
map('n', '<leader>q', function() vim.cmd("q") end, { desc = "Quit current buffer" })
map('n', '<leader>w', function() vim.cmd("w") end, { desc = "Save current buffer" })

-- Terminal
map('n', '<C-t>', function() vim.cmd("split | terminal") end, { desc = "Open terminal in split" })
map('t', '<C-t>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

map('n', '<C-z>', ':undo<CR>', { noremap = true, silent = true, desc = "Undo" })
map('n', '<C-r>', ':redo<CR>', { noremap = true, silent = true, desc = "Redo" })

map('n', 'n', 'nzzzv', { desc = "Next search result" })
map('n', 'N', 'Nzzzv', { desc = "Previous search result" })

map('n', 'r', '', { noremap = true, silent = true, desc = "Disabled to prevent accidental recording" })

-- Movement and Cursor Centering

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move section down" })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move section up" })

map('n', '<C-d>', '<C-d>zz', { desc = "Scroll down" })
map('n', '<C-u>', '<C-u>zz', { desc = "Scroll up" })

-- Enhanced cursor centering keymaps
map('n', 'zz', 'zz', { desc = "Center cursor (default)" })
map('n', '<leader>z', 'zz', { desc = "Center cursor manually" })
map('n', 'G', 'Gzz', { desc = "Go to end and center" })
map('n', 'gg', 'ggzz', { desc = "Go to start and center" })

-- Center cursor after common navigation commands
map('n', '}', '}zz', { desc = "Next paragraph and center" })
map('n', '{', '{zz', { desc = "Previous paragraph and center" })
map('n', '*', '*zz', { desc = "Search word forward and center" })
map('n', '#', '#zz', { desc = "Search word backward and center" })

-- Jump list navigation with centering
map('n', '<C-o>', '<C-o>zz', { desc = "Jump back and center" })
map('n', '<C-i>', '<C-i>zz', { desc = "Jump forward and center" })

-- map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quick Navigation
map('n', '<C-j>', function() vim.cmd("cnext") end)
map('n', '<C-k>', function() vim.cmd("cprev") end)

-- Clipboard
map('v', '<leader>y', '"+y', { desc = 'Copy to system Clipboard' })
map('n', '<leader>yy', '"+yy', { desc = 'Copy line to system Clipboard' })
map('n', '<leader>yf', function()
    local file_content = vim.fn.join(vim.fn.getline(1, '$'), '\n')
    local ok, osc52 = pcall(require, 'osc52')
    if ok then
        osc52.copy(file_content)
        vim.notify('Copied file content to clipboard', vim.log.levels.INFO)
    else
        -- Fallback to system clipboard
        vim.fn.setreg('+', file_content)
        vim.notify('Copied file content to clipboard (fallback)', vim.log.levels.INFO)
    end
end, { desc = 'Copy file content to system clipboard (OSC52)' })
map('n', '<leader>yp', utils.copy_relative_path,
    { desc = 'Copy relative project path with cursor position to clipboard' })
map('n', '<C-v>', '"+p', { desc = 'Paste from system Clipboard' })


map('n', '<C-a>', 'ggVG', { desc = 'Select file content', noremap = true, silent = true })


-- Tools
map('n', '<leader>jq', ":%!jq .<CR>", { desc = 'Format json' })
map('n', '<leader>jf', function()
    local filter = vim.fn.input('Enter jq filter: ', 'unique')
    if filter ~= '' then
        vim.cmd(string.format('%%!jq %q', filter))
    end
end, { desc = 'Run jq filter' })
map('n', '<leader>jp', function()
    local ok, heilgar = pcall(require, 'heilgar.jmespath')
    if ok then
        heilgar.search_json()
    else
        vim.notify('JMESPath functionality not available', vim.log.levels.WARN)
    end
end, { desc = 'Run JMESPath query on current JSON buffer' })

-- Docs
map('n', '<leader>sd', utils.open_docs_for_symbol, { desc = 'Open docs for symbol' })

-- Highlight Search
map('n', '<leader>nh', function() vim.cmd('nohlsearch') end, { desc = 'Clear highlight' })



-- Function to find matching quote/backtick
local function find_matching_quote(quote_char)
    local line = vim.api.nvim_get_current_line()
    local cur_col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local first_quote = nil
    local second_quote = nil

    -- Find all instances of the quote character in the current line
    for i = 1, #line do
        -- Skip if the quote is escaped
        if line:sub(i, i) == quote_char and (i == 1 or line:sub(i - 1, i - 1) ~= "\\") then
            if not first_quote then
                first_quote = i
            else
                second_quote = i
                -- If we've found a pair and our cursor is at/before first quote,
                -- or we're after first quote but before/at second quote, this is our pair
                if (cur_col <= first_quote) or (cur_col > first_quote and cur_col <= second_quote) then
                    break
                end
                -- Reset for next pair
                first_quote = nil
                second_quote = nil
            end
        end
    end

    return first_quote, second_quote
end

-- Function to jump to matching symbol
local function jump_to_matching_symbol()
    local line = vim.api.nvim_get_current_line()
    local cur_pos = vim.api.nvim_win_get_cursor(0)
    local cur_col = cur_pos[2] + 1
    local char = line:sub(cur_col, cur_col)

    -- Define matching pairs
    local pairs = {
        ['('] = ')',
        [')'] = '(',
        ['['] = ']',
        [']'] = '[',
        ['{'] = '}',
        ['}'] = '{',
        ['`'] = '`',
        ['"'] = '"',
        ["'"] = "'",
    }

    -- Handle quotes and backticks
    if char == "'" or char == '"' or char == '`' then
        local first, second = find_matching_quote(char)
        if first and second then
            if cur_col == first then
                vim.api.nvim_win_set_cursor(0, { cur_pos[1], second - 1 })
            else
                vim.api.nvim_win_set_cursor(0, { cur_pos[1], first - 1 })
            end
        end
        return
    end

    -- Check if we're on a bracket
    if pairs[char] then
        vim.cmd([[normal! %]])
        return
    end

    -- Check if we're one character after an opening symbol
    local prev_char = line:sub(cur_col - 1, cur_col - 1)
    if pairs[prev_char] then
        vim.cmd([[normal! h%]])
        return
    end

    -- Check if we're before a quote or backtick
    local next_char = line:sub(cur_col + 1, cur_col + 1)
    if next_char == "'" or next_char == '"' or next_char == '`' then
        local first, second = find_matching_quote(next_char)
        if first and second then
            vim.api.nvim_win_set_cursor(0, { cur_pos[1], second - 1 })
        end
        return
    end
end

-- Create the keymapping
map('n', '<leader>jj', jump_to_matching_symbol,
    { noremap = true, silent = true, desc = 'Jump to closing/opening matching symbol' })

-- Optional: Add visual mode mapping
map('v', '<leader>jj', jump_to_matching_symbol,
    { noremap = true, silent = true, desc = 'Jump to closing/opening matching symbol' })

-- DAP Debugging
map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
map('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Continue debugging' })
map('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step into' })
map('n', '<leader>do', function() require('dap').step_over() end, { desc = 'Step over' })
map('n', '<leader>du', function() require('dap').step_out() end, { desc = 'Step out' })
map('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'Open REPL' })
map('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run last' })
map('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Terminate debugging' })
map('n', '<leader>dui', function()
    local success, dapui = pcall(require, 'dapui')
    if success then
        dapui.toggle()
    else
        vim.notify("DAP UI not available", vim.log.levels.WARN)
    end
end, { desc = 'Toggle DAP UI' })

-- DAP Telescope
map('n', '<leader>dcc', function()
    local telescope_available, telescope = pcall(require, 'telescope')
    if telescope_available and telescope.extensions and telescope.extensions.dap then
        telescope.extensions.dap.commands()
    else
        vim.notify("Telescope DAP extension not available", vim.log.levels.WARN)
    end
end, { desc = 'DAP commands' })
map('n', '<leader>dco', function()
    local telescope_available, telescope = pcall(require, 'telescope')
    if telescope_available and telescope.extensions and telescope.extensions.dap then
        telescope.extensions.dap.configurations()
    else
        vim.notify("Telescope DAP extension not available", vim.log.levels.WARN)
    end
end, { desc = 'DAP configurations' })
map('n', '<leader>dbl', function()
    local telescope_available, telescope = pcall(require, 'telescope')
    if telescope_available and telescope.extensions and telescope.extensions.dap then
        telescope.extensions.dap.list_breakpoints()
    else
        vim.notify("Telescope DAP extension not available", vim.log.levels.WARN)
    end
end, { desc = 'List breakpoints' })
map('n', '<leader>dva', function()
    local telescope_available, telescope = pcall(require, 'telescope')
    if telescope_available and telescope.extensions and telescope.extensions.dap then
        telescope.extensions.dap.variables()
    else
        vim.notify("Telescope DAP extension not available", vim.log.levels.WARN)
    end
end, { desc = 'DAP variables' })
map('n', '<leader>dfr', function()
    local telescope_available, telescope = pcall(require, 'telescope')
    if telescope_available and telescope.extensions and telescope.extensions.dap then
        telescope.extensions.dap.frames()
    else
        vim.notify("Telescope DAP extension not available", vim.log.levels.WARN)
    end
end, { desc = 'DAP frames' })

-- DAP Configuration Management
map('n', '<leader>dlc', function() vim.cmd('DapLoadConfigs') end, { desc = 'Load DAP configs from workspace' })
map('n', '<leader>dsc', function() vim.cmd('DapShowConfigs') end, { desc = 'Show DAP configurations' })
map('n', '<leader>did', function() vim.cmd('DapInstallDebugpy') end, { desc = 'Install debugpy for DAP' })

-- Git Change Navigation
map('n', ']c', function()
    if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
    else
        require('gitsigns').next_hunk()
    end
end, { desc = 'Next git change' })

map('n', '[c', function()
    if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
    else
        require('gitsigns').prev_hunk()
    end
end, { desc = 'Previous git change' })

-- LSP Code Actions (when LSP is available)
map('n', '<leader>cu', function()
    local ok = pcall(function()
        local lsp_keymaps = require('lspconfig.keymaps')
        -- Access the smart_code_action function through module internals
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        if #clients == 0 then
            vim.notify("No LSP clients attached", vim.log.levels.WARN)
            return
        end

        -- Call remove unused directly
        vim.lsp.buf.code_action({
            context = { only = { 'source.removeUnused' } },
            apply = true,
        })
    end)

    if not ok then
        vim.notify("Clean imports not available (no LSP)", vim.log.levels.WARN)
    end
end, { desc = 'Clean unused imports' })
