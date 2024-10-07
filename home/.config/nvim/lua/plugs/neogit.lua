return {
    "NeogitOrg/neogit",
    dependencies = {
        "sindrets/diffview.nvim",
    },
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("neogit").setup {
            auto_show_console = false,
        }
    end
}
