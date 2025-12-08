function ColorMyPencils(color)
  -- color = color or "gruvbox"
  color = color or "vague"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vague").setup({})
      vim.cmd("colorscheme vague")
    end
  },
}

