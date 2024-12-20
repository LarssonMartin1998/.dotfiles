return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    lazy = true,
    opts = {
        -- Make sure that we never get whitespaces when adding surroundings
        surrounds = {
            ["("] = { add = { "(", ")" }, },
            ["{"] = { add = { "{", "}" }, },
            ["<"] = { add = { "<", ">" }, },
            ["["] = { add = { "[", "]" }, },
        }
    }
}
