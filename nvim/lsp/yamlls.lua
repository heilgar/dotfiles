return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.kubernetes' },
    root_markers = { '.git', 'kustomization.yaml', 'kustomization.yml', 'Chart.yaml' },
    capabilities = {
        offsetEncoding = { 'utf-16' },
        positionEncodings = { 'utf-16' },
    },
    settings = {
        yaml = {
            -- Kubernetes schema support
            kubernetes = {
                'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json'
            },
            schemas = {
                -- Kubernetes schemas
                ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json'] = {
                    '*.k8s.yaml',
                    '*.k8s.yml',
                    '**/k8s/**/*.yaml',
                    '**/k8s/**/*.yml',
                    '**/kubernetes/**/*.yaml',
                    '**/kubernetes/**/*.yml',
                    '**/manifests/**/*.yaml',
                    '**/manifests/**/*.yml',
                },
                -- Docker Compose schemas  
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
                    'docker-compose*.yml',
                    'docker-compose*.yaml',
                    'compose*.yml',
                    'compose*.yaml',
                },
                -- GitHub Actions
                ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*.{yml,yaml}',
                -- CI/CD
                ['https://json.schemastore.org/gitlab-ci.json'] = '.gitlab-ci.yml',
                ['https://json.schemastore.org/azure-pipelines.json'] = 'azure-pipelines.yml',
            },
            format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
            },
            validate = true,
            completion = true,
            hover = true,
            -- Disable yamlls for files handled by other servers
            disableAdditionalProperties = false,
            -- Custom tags for Kubernetes
            customTags = {
                '!Ref',
                '!Base64',
                '!GetAtt',
                '!GetAZs',
                '!ImportValue',
                '!Join',
                '!Ref',
                '!Select',
                '!Split',
                '!Sub'
            },
        }
    }
} 