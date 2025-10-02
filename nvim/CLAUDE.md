# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a high-performance Neovim configuration designed for modern development workflows with aggressive lazy loading for lightning-fast startup times (~200-400ms). The configuration automatically detects project types and loads relevant LSP servers and tools based on file patterns.

## Development Commands

### LSP Server Management
```bash
# Check LSP binary availability
zsh check-lsp-binaries.zsh

# Within Neovim - install LSP servers for project types
:LspInstallFor web       # TypeScript, JavaScript, HTML, ESLint
:LspInstallFor python    # Python language server  
:LspInstallFor golang    # Go language server
:LspInstallFor devops    # Docker, Terraform, YAML
:LspStatus               # Check current project status
```

### Plugin Management
```vim
:Lazy                    # Open plugin manager
:Lazy profile            # Check plugin load times
:Lazy sync               # Update all plugins
```

### Diagnostics & Performance
```vim
# View startup time (displayed automatically on launch)
:lua print(vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time)))

# Memory usage
:lua print(collectgarbage("count") .. " KB")

# LSP information
:LspInfo                 # Active LSP servers
```

## Architecture Overview

### Core Structure
- `init.lua` - Main entry point with performance optimizations and module loading
- `lua/core/` - Core Neovim configuration (options, keymaps, autocmds, lazy loading)
- `lua/lspconfig/` - LSP server configurations and keymaps
- `lua/plugins/` - Plugin specifications organized by category
- `lsp/` - Individual LSP server configurations

### Performance Architecture
The configuration uses several performance strategies:

1. **Aggressive Lazy Loading**: Plugins load only when needed via lazy.nvim
2. **Smart LSP Management**: Context-aware server loading based on project detection
3. **File Size Awareness**: Automatic optimizations for large files (>50KB, >1000 lines)
4. **Disabled Built-ins**: Several Neovim built-in plugins are disabled for speed

### Project Detection System
The configuration automatically detects project types and loads appropriate tools:

| Project Type | Detection Files | Loaded Servers |
|-------------|-----------------|----------------|
| **Web** | `package.json`, `tsconfig.json` | TypeScript, HTML, ESLint |
| **Python** | `requirements.txt`, `pyproject.toml` | Pyright, Ruff |
| **Go** | `go.mod`, `go.sum` | Gopls |
| **DevOps** | `Dockerfile`, `*.tf`, `*.yaml` | Docker, Terraform, YAML LSP |

### Plugin Organization
- `plugins/editor/` - Core editing enhancements (Telescope, Treesitter, etc.)
- `plugins/tools/` - External tool integrations (Git, AI, DAP debugging)
- `plugins/ui/` - User interface components (colorscheme, statusline)

### LSP Configuration Architecture
- `lua/lspconfig/lsp.lua` - Main LSP setup using `vim.lsp.enable()`
- `lua/lspconfig/keymaps.lua` - LSP-specific keymaps setup
- Individual server configs in `lsp/` directory (e.g., `lsp/pyright.lua`, `lsp/clangd.lua`)

### Performance Optimizations
- File size thresholds: 50KB for formatting, 1000 lines for heavy operations  
- Reduced timeouts: LSP formatting (1s), yank highlight (300ms)
- Disabled change detection and auto-checking in lazy.nvim
- Smart autocmd management with performance guards

### Custom Utilities
- `lua/core/utils.lua` - Language-aware import organization, documentation lookup, path copying
- `lua/core/python_venv.lua` - Automatic Python virtual environment detection
- `lua/core/autocmds.lua` - Performance-optimized autocmds for file cleanup and formatting

### Debug Adapter Protocol (DAP)
The configuration includes comprehensive DAP support with workspace configuration loading:
- Supports `.vscode/launch.json`, `.nvim/launch.json`, `.dap/launch.json`
- Automatic `${workspaceFolder}` variable substitution
- Python debugging with `debugpy` integration

### AI Integration
- GitHub Copilot via `copilot.vim`
- Claude Code integration via `claude-code.nvim` (toggle with `<leader>ac`)

## Key Design Decisions

1. **Startup Performance Priority**: All optimizations favor faster startup over convenience features
2. **Project-Aware Loading**: LSP servers and tools load based on detected project type rather than being always available
3. **Lazy Loading Strategy**: Plugins load on commands, keys, or filetypes rather than at startup
4. **Large File Handling**: Automatic performance degradation for files exceeding size thresholds
5. **Unix Line Endings**: All files are automatically converted to LF line endings on save