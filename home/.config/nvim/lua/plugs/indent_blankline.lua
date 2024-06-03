return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        require("ibl").setup({
            debounce = 100,
            scope = {
                enabled = false
            },
        })
    end
}
