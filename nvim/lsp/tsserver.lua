return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "vue",
        "svelte",
    },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    init_options = {
        hostInfo = "neovim",
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/path/to/node_modules/@vue/language-server",
                languages = { "vue" },
            },
        },
    },
}