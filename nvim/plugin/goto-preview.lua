local function gh(repo)
    return "https://github.com/" .. repo
end

vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        vim.pack.add({
            gh("https://github.com/rmagatti/goto-preview"),
            gh("rmagatti/logger.nvim")
        })
        require("goto-preview").setup({
            border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
            focus_on_open = true,
            stack_floating_preview_windows = false,
            preview_window_title = { enable = true, position = "left" },
            vim_ui_input = false,
        })

        require("utils").set_keymap_list({
            { "gp",        function() require("goto-preview").goto_preview_definition() end },
            { "gy",        function() require("goto-preview").goto_preview_type_definition() end },
            { "<Leader>q", function() require("goto-preview").close_all_win() end },
        })
    end,
})
