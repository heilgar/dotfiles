return {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars', 'hcl' },
    root_markers = { '.terraform', '.git', 'main.tf', 'terraform.tf' },
    capabilities = {
        offsetEncoding = { 'utf-16' },
        positionEncodings = { 'utf-16' },
    },
    settings = {
        terraformls = {
            -- Enable experimental features if desired
            experimentalFeatures = {
                validateOnSave = true,
                prefillRequiredFields = true,
            },
            -- Terraform binary path (optional)
            -- terraformExecPath = "/usr/local/bin/terraform",
            -- Terraform log level
            terraformLogFilePath = "",
        }
    }
} 