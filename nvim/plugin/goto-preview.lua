vim.schedule(function()
    vim.pack.add({
        "https://github.com/rmagatti/logger.nvim",
        "https://github.com/rmagatti/goto-preview",
    })

    require("goto-preview").setup({
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        focus_on_open = true,
        stack_floating_preview_windows = false,
        preview_window_title = { enable = true, position = "left" },
        vim_ui_input = false,
    })

    local utils = require("utils")
    utils.set_keymap_list({
        { "gp",        function() require("goto-preview").goto_preview_definition() end },
        { "gy",        function() require("goto-preview").goto_preview_type_definition() end },
        { "<Leader>q", function() require("goto-preview").close_all_win() end },
    })
end)
