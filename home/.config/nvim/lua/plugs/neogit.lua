return {
    "NeogitOrg/neogit",
    dependencies = {
        "sindrets/diffview.nvim",
    },
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("neogit").setup()
    end
}
