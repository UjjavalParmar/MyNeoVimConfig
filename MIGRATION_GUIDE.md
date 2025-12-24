# Migration Guide: lazy.nvim to vim-pack

This guide explains how to migrate from lazy.nvim to Neovim's built-in vim-pack package manager.

## What Changed

### Directory Structure
- **Old**: Plugins managed by lazy.nvim in `~/.local/share/nvim/lazy/`
- **New**: Plugins installed in `~/.config/nvim/pack/plugins/start/`

### Configuration Files
- **Old**: Plugin specs in `lua/ujjj/lazy/*.lua`
- **New**: Plugin configurations in `plugin/*.lua`

### Removed Files
The following lazy.nvim-specific files are no longer needed:
- `lua/ujjj/lazy_init.lua` - Lazy bootstrap script
- `lua/ujjj/lazy/*.lua` - Lazy plugin specifications
- `lazy-lock.json` - Lazy lockfile

## Installation Steps

### 1. Install Plugins

Run the installation script to clone all plugins:

```bash
cd ~/.config/nvim
./install_plugins.sh
```

This script will:
- Create the `pack/plugins/start/` directory
- Clone all required plugins from GitHub
- Update existing plugins if already installed

### 2. Generate Help Tags

Open Neovim and run:

```vim
:helptags ALL
```

This generates documentation for all installed plugins.

### 3. Verify Installation

Check that all plugins loaded correctly:

```vim
:scriptnames
```

You should see entries from `pack/plugins/start/`.

### 4. Clean Up (Optional)

Remove old lazy.nvim files:

```bash
# Remove lazy.nvim plugin manager
rm -rf ~/.local/share/nvim/lazy

# Remove lazy configuration files
rm -rf ~/.config/nvim/lua/ujjj/lazy
rm -f ~/.config/nvim/lua/ujjj/lazy_init.lua
rm -f ~/.config/nvim/lazy-lock.json
```

## Plugin Configuration Reference

All plugin configurations are now in the `plugin/` directory:

- `plugin/lsp.lua` - LSP, Mason, nvim-cmp, Conform
- `plugin/snippets.lua` - LuaSnip keybindings
- `plugin/treesitter.lua` - Tree-sitter configuration
- `plugin/colors.lua` - Colorscheme (vague theme)
- `plugin/telescope.lua` - Fuzzy finder keybindings
- `plugin/undotree.lua` - Undo tree toggle
- `plugin/trouble.lua` - Diagnostics viewer
- `plugin/zenmode.lua` - Distraction-free mode
- `plugin/autopairs.lua` - Auto-pairing brackets

## Updating Plugins

To update all plugins, run:

```bash
cd ~/.config/nvim/pack/plugins/start
for dir in */; do
    echo "Updating $dir..."
    cd "$dir"
    git pull
    cd ..
done
```

Or simply re-run the installation script:

```bash
cd ~/.config/nvim
./install_plugins.sh
```

## Adding New Plugins

To add a new plugin:

1. Edit `install_plugins.sh` and add the plugin to the `plugins` array:
   ```bash
   "owner/repo-name"
   ```

2. Run the installation script:
   ```bash
   ./install_plugins.sh
   ```

3. Create a configuration file in `plugin/` if needed:
   ```bash
   touch plugin/myplugin.lua
   ```

4. Add your plugin configuration to the new file.

## Removing Plugins

To remove a plugin:

1. Delete its directory:
   ```bash
   rm -rf ~/.config/nvim/pack/plugins/start/plugin-name
   ```

2. Delete its configuration file (if it exists):
   ```bash
   rm ~/.config/nvim/plugin/plugin-name.lua
   ```

3. Remove it from `install_plugins.sh` to prevent reinstallation.

## Troubleshooting

### Plugin Not Loading

Check if the plugin is in the correct directory:
```bash
ls ~/.config/nvim/pack/plugins/start/
```

### Configuration Errors

Check for Lua syntax errors:
```vim
:messages
```

### Missing Dependencies

Ensure all required plugins are installed. Check `install_plugins.sh` for the complete list.

## Benefits of vim-pack

- **No plugin manager overhead**: One less dependency
- **Faster startup**: Native Neovim functionality
- **Simpler**: Direct Git clones, easy to understand
- **Full control**: Manual plugin management

## Notes

- LuaSnip requires `make install_jsregexp` after installation (handled by install script)
- Tree-sitter parsers are auto-installed on first use
- Mason LSP servers are auto-installed on first LSP attach
