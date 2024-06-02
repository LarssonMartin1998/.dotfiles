return {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup({})

        require("utils").add_keymaps({
            n = {
                ["<leader>x"] = {
                    cmd = "<cmd>Trouble diagnostics toggle<cr>",
                },
                ["<leader>ls"] = {
                    cmd = "<cmd>Trouble symbols toggle focus=false<cr>",
                },
                -- Stick with using the references feature fom lspsaga for now, might change later
                -- ["<leader>cl"] = {
                --     cmd = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                -- },
                ["<leader>ll"] = {
                    cmd = "<cmd>Trouble loclist toggle<cr>",
                },
                ["<leader>lq"] = {
                    cmd = "<cmd>Trouble qflist toggle<cr>",
                },
            }
        })
    end
}
