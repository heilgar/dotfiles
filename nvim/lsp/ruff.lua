return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'requirements.txt', '.git', 'setup.py', 'setup.cfg', 'ruff.toml', '.ruff.toml' },
    capabilities = {
        offsetEncoding = { 'utf-16' },
        positionEncodings = { 'utf-16' },
    },
    init_options = {
        settings = {
            -- Ruff language server settings
            logLevel = 'info',  -- Can be 'debug', 'info', 'warn', 'error'
            -- logFile = '/path/to/ruff.log',  -- Optional: divert logs to file
        }
    }
}