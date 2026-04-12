vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/rachartier/tiny-glimmer.nvim" })
        require("tiny-glimmer").setup({
            refresh_interval_ms = 6,
            overwrite = {
                auto_map = true,
                paste = {
                    enabled = true,
                    default_animation = { name = "fade", settings = { from_color = "DiffText" } },
                },
                undo = {
                    enabled = true,
                    default_animation = { name = "fade", settings = { from_color = "DiffDelete" } },
                },
                redo = {
                    enabled = true,
                    default_animation = { name = "fade", settings = { from_color = "DiffAdd" } },
                },
            },
            animations = {
                fade = {
                    chars_for_max_duration = 1,
                    to_color = "Folded",
                },
            },
        })
    end,
})
