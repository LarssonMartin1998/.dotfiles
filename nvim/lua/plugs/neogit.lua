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
    opts = {},
    keys = {
        { "<leader>g", function() require("neogit").open() end }
    },
}
