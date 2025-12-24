#!/bin/bash

# Vim-pack plugin installation script
# This script clones all plugins into the pack/plugins/start directory

PACK_DIR="$HOME/.config/nvim/pack/plugins/start"

echo "Installing plugins to $PACK_DIR..."

# Create directory if it doesn't exist
mkdir -p "$PACK_DIR"

# Plugin list (format: "owner/repo")
declare -a plugins=(
    # LSP & Completion
    "neovim/nvim-lspconfig"
    "stevearc/conform.nvim"
    "williamboman/mason.nvim"
    "williamboman/mason-lspconfig.nvim"
    "hrsh7th/nvim-cmp"
    "hrsh7th/cmp-nvim-lsp"
    "hrsh7th/cmp-buffer"
    "hrsh7th/cmp-path"
    "hrsh7th/cmp-cmdline"
    "L3MON4D3/LuaSnip"
    "saadparwaiz1/cmp_luasnip"
    "j-hui/fidget.nvim"
    "rafamadriz/friendly-snippets"

    # Treesitter
    "nvim-treesitter/nvim-treesitter"

    # Colorscheme
    "vague-theme/vague.nvim"

    # Telescope
    "nvim-telescope/telescope.nvim"
    "nvim-lua/plenary.nvim"

    # Utilities
    "mbbill/undotree"
    "folke/trouble.nvim"
    "folke/zen-mode.nvim"
    "windwp/nvim-autopairs"
)

# Clone or update each plugin
for plugin in "${plugins[@]}"; do
    plugin_name=$(basename "$plugin")
    plugin_dir="$PACK_DIR/$plugin_name"

    if [ -d "$plugin_dir" ]; then
        echo "Updating $plugin_name..."
        cd "$plugin_dir"
        git pull
    else
        echo "Installing $plugin_name..."
        git clone --depth 1 "https://github.com/$plugin.git" "$plugin_dir"
    fi

    # Special build steps for certain plugins
    if [ "$plugin_name" = "LuaSnip" ]; then
        echo "Building LuaSnip..."
        cd "$plugin_dir"
        make install_jsregexp
    fi
done

echo ""
echo "All plugins installed successfully!"
echo "Run :helptags ALL in Neovim to generate help tags"
