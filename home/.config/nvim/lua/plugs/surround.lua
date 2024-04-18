return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Make sure that we never get whitespaces when adding surroundings
            surrounds = {
                ["("] = { add = { "(", ")" }, },
                ["{"] = { add = { "{", "}" }, },
                ["<"] = { add = { "<", ">" }, },
                ["["] = { add = { "[", "]" }, },
            }
        })
    end,
}
