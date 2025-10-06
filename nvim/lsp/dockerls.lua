return {
    cmd = { 'docker-language-server', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile', 'Dockerfile.*', '.git' },
    capabilities = {
        offsetEncoding = { 'utf-16' },
        positionEncodings = { 'utf-16' },
    },
    settings = {
        docker = {
            languageserver = {
                formatter = {
                    ignoreMultilineInstructions = true,
                },
            },
        },
    }
}
