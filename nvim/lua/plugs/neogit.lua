return {
    "NeogitOrg/neogit",
    dependencies = {
        {
            "sindrets/diffview.nvim",
            opts = {
                view = {
                    merge_tool = {
                        layout = "diff1_plain",
                    },
                },
            },
        }
    },
    event = "VeryLazy",
    lazy = true,
    config = function()
        local neogit = require("neogit")
        neogit.setup()

        require("utils").add_keymaps({
            n = {
                ["<leader>g"] = {
                    cmd = function() neogit.open({ kind = "vsplit" }) end,
                },
            }
        })
    end
}
