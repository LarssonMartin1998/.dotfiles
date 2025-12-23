return {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    lazy = true,
    opts = {},
    keys = {
        { "<leader>v", function() require("neogit").open() end }
    },
}
