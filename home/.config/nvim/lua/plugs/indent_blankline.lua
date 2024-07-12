return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufRead",
    opts = {
        debounce = 100,
        scope = {
            enabled = false
        },
    }
}
