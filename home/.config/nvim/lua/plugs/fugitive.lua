return {
    "tpope/vim-fugitive",
    config = function()
        require("utils").add_keymaps({
            n = {
                ["<leader>gp"] = {
                    cmd = ":Gitsigns preview_hunk_inline<CR>",
                },
                ["<leader>gt"] = {
                    cmd = ":Gitsigns toggle_current_line_blame<CR>",
                },
                ["<leader>gb"] = {
                    cmd = ":Git blame<CR>",
                }
            }
        })
    end
}
