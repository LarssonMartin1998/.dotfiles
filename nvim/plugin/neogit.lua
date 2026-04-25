local utils = require("utils")

utils.set_keymap_list({
    { "<leader>v", function()
        vim.pack.add({
            "https://github.com/nvim-lua/plenary.nvim",
            "https://github.com/NeogitOrg/neogit",
        })
        local p = require("norrsken.palette")
        require("neogit").setup({
            highlight = {
                italic = false,
                bold = true,
                underline = true,
                green = p.green,
                red = p.red,
            },
        })
        require("norrsken.integrations.neogit")()
        utils.set_keymap_list({
            { "<leader>v", function() require("neogit").open() end },
        })
        require("neogit").open()
    end },
})
