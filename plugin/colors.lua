-- Colorscheme configuration
-- Converted from lazy.nvim to vim-pack

function ColorMyPencils(color)
  -- color = color or "gruvbox"
  color = color or "vague"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

require("vague").setup({})
vim.cmd("colorscheme vague")
