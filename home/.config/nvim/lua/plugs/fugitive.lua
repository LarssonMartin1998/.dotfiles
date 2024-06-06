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
                ["<leader>ga"] = {
                    cmd = ":Gwrite<CR>",
                },
                ["<Leader>gr"] = {
                    cmd = ":Gread<CR>",
                },
                ["<Leader>gs"] = {
                    cmd = ":G<CR>",
                },
                ["<Leader>gd"] = {
                    cmd = ":Gdiffsplit<CR>",
                },
                ["<Leader>gc"] = {
                    cmd = ":G commit<CR>",
                },
                ["<Leader>gl"] = {
                    cmd = ":G log<CR>",
                },
                ["<Leader>gb"] = {
                    cmd = ":G blame<CR>",
                },
            }
        })
    end
}
