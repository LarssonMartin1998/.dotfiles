return {
    "otavioschwanck/arrow.nvim",
    opts = {
        show_icons = true,
        leader_key = ",",
        global_bookmarks = true,
        custom_actions = {
            open = function(filename, _)
                vim.cmd(string.format(":drop %s", filename))
            end,
        },
        mappings = {
            edit = "e",
            delete_mode = "d",
            clear_all_items = "C",
            toggle = "s",
            open_vertical = "v",
            open_horizontal = "h",
            quit = "q",
            remove = "x",
            next_item = "n",
            prev_item = "p",
        }
    }
}
