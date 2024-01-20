return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
        require("telescope").setup({ })
        require("telescope").load_extension("fzf")

        local keymaps = {
            n = {
                -- File search
                ["<leader>to"] = {
                    cmd = ":Telescope find_files <CR>",
                },
                ["<leader>tf"] = {
                    cmd = ":Telescope current_buffer_fuzzy_find<CR>",
                },
                ["<leader>ta"] = {
                    cmd = ":Telescope live_grep find_command=rg,--ignore-file,.gitignore,--exclude,*.git,--exclude,*.svn,--exclude,*.vs,--exclude,*.idea<CR>",
                },
                -- Git
                ["<leader>gc"] = { 
                    cmd = "<cmd> Telescope git_commits <CR>",
                },
                ["<leader>gs"] = { 
                    cmd = "<cmd> Telescope git_status <CR>",
                },
                ["<leader>gh"] = { 
                    cmd = "<cmd> Telescope git_bcommits <CR>",
                },
                ["<leader>gb"] = { 
                    cmd = "<cmd> Telescope git_branches <CR>",
                },
                -- Misc
                ["<leader>tb"] = {
                    cmd = "<cmd> Telescope marks <CR>",
                }
            }
        }

        require("utils").add_keymaps(keymaps)
    end,
}
