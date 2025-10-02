local M = {}

local venv_python = vim.fn.getcwd() .. '/.venv/bin/python'

if vim.fn.filereadable(venv_python) == 1 then
    vim.g.python3_host_prog = venv_python
end

function M.get_venv_python()
    if vim.fn.filereadable(venv_python) == 1 then
        return venv_python
    end
    return nil
end

return M 