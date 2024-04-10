return {
    "ggandor/leap.nvim",
    dependencies = {
        "tpope/vim-repeat",
    },
    config = function()
        local leap = require("leap")
        leap.opts.safe_labels = {}

        -- Hide the (real) cursor when leaping, and restore it afterwards.
        vim.api.nvim_create_autocmd(
            "User",
            {
                pattern = "LeapEnter",
                callback = function()
                    vim.cmd.hi("Cursor", "blend=100")
                    vim.opt.guicursor:append { "a:Cursor/lCursor" }
                end,
            }
        )
        vim.api.nvim_create_autocmd(
            "User",
            {
                pattern = "LeapLeave",
                callback = function()
                    vim.cmd.hi("Cursor", "blend=0")
                    vim.opt.guicursor:remove { "a:Cursor/lCursor" }
                end,
            }
        )

        require("utils").add_keymaps({
            n = {
                ["l"] = {
                    cmd = function()
                        require("leap").leap({ target_windows = require("leap.user").get_focusable_windows() })
                    end,
                }
            }
        })
    end,
}
