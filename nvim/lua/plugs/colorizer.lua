return {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    lazy = true,
    opts = {
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
    }
}
