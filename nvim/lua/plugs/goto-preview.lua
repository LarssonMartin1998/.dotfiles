local close_handler = require("close_handler")

local close_cb_handle = 0

return {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    opts = {
        post_open_hook = function(_, _)
            close_cb_handle = close_handler.register_on_close_cb(function()
                require("goto-preview").close_all_win()
            end)
        end,
        post_close_hook = function(_, _)
            close_handler.remove_on_close_cb(close_cb_handle)
        end,
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        focus_on_open = true,
        stack_floating_preview_windows = false,
        preview_window_title = { enable = true, position = "left" },
        vim_ui_input = false,
    },
    keys = {
        { "gp", function() require("goto-preview").goto_preview_definition() end, },
        { "gy", function() require("goto-preview").goto_preview_type_definition() end, },
    },
}
