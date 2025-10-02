# DAP (Debug Adapter Protocol) Configuration

This Neovim setup includes comprehensive DAP support for Python debugging with workspace configuration loading.

## Features

- **Workspace Configuration Loading**: Automatically loads DAP configurations from workspace files
- **Multiple Configuration Sources**: Supports `.vscode/launch.json`, `.nvim/launch.json`, `.dap/launch.json`, and `launch.json`
- **Path Mapping Support**: Handles `${workspaceFolder}` variable substitution
- **DAP UI Integration**: Full debugging interface with scopes, breakpoints, and REPL
- **Telescope Integration**: Browse configurations, breakpoints, and variables

## Workspace Configuration

The DAP setup automatically loads configurations from the following files in your workspace:

1. `.vscode/launch.json` (VSCode compatible)
2. `.nvim/launch.json` (Neovim specific)
3. `.dap/launch.json` (DAP specific)
4. `launch.json` (Root level)

### Example `.vscode/launch.json`

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Attach",
            "type": "python",
            "request": "attach",
            "redirectOutput": true,
            "connect": {
                "host": "127.0.0.1",
                "port": 5678
            },
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "/app"
                }
            ],
            "justMyCode": true
        }
    ]
}
```

## Keybindings

### Debug Controls
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - Step out
- `<leader>dr` - Open REPL
- `<leader>dl` - Run last configuration
- `<leader>dt` - Terminate debugging
- `<leader>dui` - Toggle DAP UI

### Telescope DAP
- `<leader>dcc` - DAP commands
- `<leader>dco` - DAP configurations
- `<leader>dbl` - List breakpoints
- `<leader>dva` - DAP variables
- `<leader>dfr` - DAP frames

### Configuration Management
- `<leader>dlc` - Load DAP configs from workspace
- `<leader>dsc` - Show DAP configurations

## Commands

- `:DapLoadConfigs` - Reload configurations from workspace files
- `:DapShowConfigs` - Show current DAP configurations

## Usage

1. **Setup your Python application for remote debugging**:
   ```python
   import debugpy
   debugpy.listen(("127.0.0.1", 5678))
   debugpy.wait_for_client()
   ```

2. **Create a `.vscode/launch.json` file** in your project with your debug configurations

3. **Start debugging**:
   - Use `<leader>dco` to select a configuration
   - Or use `<leader>dc` to continue with the last configuration

4. **Set breakpoints** with `<leader>db`

5. **Use the DAP UI** with `<leader>dui` to see variables, call stack, and breakpoints

## Path Mapping

The configuration automatically handles `${workspaceFolder}` variable substitution in path mappings. For example:

```json
{
    "pathMappings": [
        {
            "localRoot": "${workspaceFolder}",
            "remoteRoot": "/app"
        }
    ]
}
```

This will be automatically converted to use the actual workspace path.

## Requirements

- `debugpy` Python package for Python debugging
- The DAP setup will be automatically installed via lazy.nvim 