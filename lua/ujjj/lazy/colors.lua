function ColorMyPencils(color)
  -- color = color or "gruvbox"
  color = color or "vague"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {

  {
    "erikbackman/brightburn.vim",
  },
  {
    "vague-theme/vague.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require("vague").setup({
        -- optional configuration here
      })
      vim.cmd("colorscheme vague")
    end
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {},
    config = function()
      ColorMyPencils()
    end
  },

  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        bold = true,
        italic = {
          strings = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        inverse = true,
        transparent_mode = false,
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
      })
    end
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
        disable_background = true,
        styles = {
          italic = false,
        },
      })
      ColorMyPencils()
    end
  },
}

