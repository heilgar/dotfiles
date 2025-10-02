return {
    -- Command and arguments to start the server.
    cmd = { 'lua-language-server' },
    -- Filetypes to automatically attach to.
    filetypes = { 'lua' },

    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a ".luarc.json" or a
    -- ".luarc.jsonc" file. Files that share a root directory will reuse
    -- the conneection to the same LSP server.
    -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    root_markers = { '.luarc.json', '.luarc.jsonc', 'lua' },

    capabilities = {
        offsetEncoding = { 'utf-16' },
        positionEncodings = { 'utf-16' },
    },

    -- Specific settings to send to the server. The schema for this is
    -- defined by the server. For example the schema for lua-language-server
    -- is defined in https://raw.githubusercontent.com/LuaLS/vscode-lua/refs/heads/master/setting/schema.json
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },

            diagnostics = { globals = { 'vim' } },
        }
    },
}

