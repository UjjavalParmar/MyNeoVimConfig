return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true,                        -- Enable treesitter integration for better pairing in certain contexts
        ts_config = {
            lua = { "string" },                 -- Disable autopair in Lua string nodes
            javascript = { "template_string" }, -- Disable autopair in JavaScript template strings
        },
        fast_wrap = {
            map = "<M-e>", -- Key mapping for wrapping around selections
            chars = { "{", "[", "(", '"', "'" },
            pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
            offset = 0,
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "PmenuSel",
            highlight_grey = "LineNr",
        }
    },
    config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- Integration with nvim-cmp if you are using it
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}

