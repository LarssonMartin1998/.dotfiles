return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup({
            DEFAULT_OPTIONS = {
                RGB = true,
                RRGGBB = true,
                names = false,
                RRGGBBAA = true,
                css = true,
                css_fn = true,
                mode = "background",
            },
            "*",
        })
    end,
}
