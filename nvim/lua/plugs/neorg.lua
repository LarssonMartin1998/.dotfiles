return {
    "nvim-neorg/neorg",
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        my_workspace = "~/.neorg",
                    },
                },
            },
            ["core.concealer"] = {},
        },
    },
    event = "VeryLazy",
    lazy = true,
}
