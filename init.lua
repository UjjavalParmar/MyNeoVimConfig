-- ============================================================================
-- Simple Neovim Configuration
-- ============================================================================

-- Leader key (space bar)
vim.g.mapleader = " "

-- ============================================================================
-- Basic Settings
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs = 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- No line wrapping
vim.opt.wrap = false

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.swapfile = false
vim.opt.backup = false

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true

-- Keep 10 lines visible when scrolling
vim.opt.scrolloff = 10

-- Always show sign column (for git/errors)
vim.opt.signcolumn = "yes"

-- Faster updates
vim.opt.updatetime = 50

-- Show line at 80 characters
vim.opt.colorcolumn = "80"

-- Other
vim.opt.guicursor = ""
vim.opt.isfname:append("@-@")

-- ============================================================================
-- Keybindings
-- ============================================================================

vim.keymap.set("n", "<leader>mm", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ bufnr = 0 })
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Highlight when copying text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 40 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  end
})

-- File explorer settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- ============================================================================
-- Colors
-- ============================================================================

function ColorMyPencils(color)
  color = color or "vague"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

require("vague").setup({})
vim.cmd("colorscheme vague")

-- ============================================================================
-- Code Formatting
-- ============================================================================

require("conform").setup({
  formatters_by_ft = {
    go = { "gofmt", "goimports" },
    python = { "black", "isort" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
  }
})

-- ============================================================================
-- LSP (Code Intelligence)
-- ============================================================================

local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities())

require("fidget").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "pyright", "terraformls" },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities
      })
    end,
  }
})

-- ============================================================================
-- Auto Completion
-- ============================================================================

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
      { name = 'buffer' },
    })
})

vim.diagnostic.config({
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- ============================================================================
-- Telescope (File Finder)
-- ============================================================================

require('telescope').setup({})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pws', function()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>pWs', function()
  local word = vim.fn.expand("<cWORD>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- ============================================================================
-- Treesitter (Syntax Highlighting)
-- ============================================================================

-- Setup treesitter (new API)
require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site'
})

-- Auto-install missing parsers when opening a file
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local lang = vim.bo.filetype

    -- Skip filetypes that don't need parsers
    local ignore_fts = {
      'netrw', 'help', 'qf', 'man', 'lspinfo', 'checkhealth',
      'TelescopePrompt', 'TelescopeResults', 'mason', 'lazy',
      'oil', 'fugitive', 'gitcommit', 'gitrebase'
    }

    if lang ~= '' and not vim.tbl_contains(ignore_fts, lang) then
      -- Try to start treesitter
      local ok = pcall(vim.treesitter.start)
      if not ok then
        -- If it fails, try to install the parser
        vim.schedule(function()
          local install_ok = pcall(require('nvim-treesitter').install, { lang })
          if install_ok then
            vim.notify('Installing treesitter parser for ' .. lang, vim.log.levels.INFO)
          end
        end)
      end
    end
  end,
})

-- Enable folding
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldmethod = 'expr'
vim.wo.foldenable = false  -- Don't fold by default

-- Enable indentation (experimental)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'python', 'terraform', 'hcl', 'lua' },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ============================================================================
-- Plugin Setups
-- ============================================================================

-- Auto close brackets
require('nvim-autopairs').setup({})

-- Snippets
local ls = require("luasnip")
vim.keymap.set({"i"}, "<C-s>e", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-s>;", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-s>,", function() ls.jump(-1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})

-- Undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Trouble (Error list)
require("trouble").setup({ icons = false })
vim.keymap.set("n", "<leader>tt", function()
  require("trouble").toggle()
end)
vim.keymap.set("n", "[t", function()
  require("trouble").next({skip_groups = true, jump = true});
end)
vim.keymap.set("n", "]t", function()
  require("trouble").previous({skip_groups = true, jump = true});
end)

-- Zen mode
vim.keymap.set("n", "<leader>zz", function()
  require("zen-mode").setup({
    window = {
      width = 90,
      options = {}
    },
  })
  require("zen-mode").toggle()
  vim.wo.wrap = false
  vim.wo.number = true
  vim.wo.rnu = true
  ColorMyPencils()
end)

vim.keymap.set("n", "<leader>zZ", function()
  require("zen-mode").setup({
    window = {
      width = 80,
      options = {}
    },
  })
  require("zen-mode").toggle()
  vim.wo.wrap = false
  vim.wo.number = false
  vim.wo.rnu = false
  vim.opt.colorcolumn = "0"
  ColorMyPencils()
end)
