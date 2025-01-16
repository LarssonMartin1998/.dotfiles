return {
    "mistricky/codesnap.nvim",
    build = "make",
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("codesnap").setup({
            mac_window_bar = true,
            title = "codesnap.nvim",
            code_font_family = "JetBrainsMono Nerd Font",
            breadcrumbs_separator = "/",
            has_breadcrumbs = true,
            bg_theme = "grape",
            watermark = "",
        })

        require("utils").add_keymaps({
            v = {
                ["<leader>cs"] = {
                    cmd = ":CodeSnap<CR>",
                    opts = { silent = true },
                },
            }
        })
    end,
}
