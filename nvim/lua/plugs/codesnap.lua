return {
    "mistricky/codesnap.nvim",
    build = "make",
    event = "VeryLazy",
    lazy = true,
    opts = {
        mac_window_bar = true,
        title = "codesnap.nvim",
        code_font_family = "JetBrainsMono Nerd Font",
        breadcrumbs_separator = "/",
        has_breadcrumbs = true,
        bg_theme = "grape",
        watermark = "",
    },
    keys = {
        { "<leader>cs", ":CodeSnap<CR>", mode = "v", silent = true, noremap = true },
    },
}
