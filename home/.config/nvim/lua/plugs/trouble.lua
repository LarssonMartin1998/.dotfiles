return {
    "folke/trouble.nvim",
    branch = "dev",
    opts = {},
    config = {

        require("utils").add_keymaps({
            n = {
                -- ["<leader>xx"] = {
                --     cmd = "<cmd>Trouble diagnostics toggle<cr>",
                -- },
                -- ["<leader>xX"] = {
                --     cmd = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                -- },
                -- ["<leader>cs"] = {
                --     cmd = "<cmd>Trouble symbols toggle focus=false<cr>",
                -- },
                -- ["<leader>cl"] = {
                --     cmd = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                -- },
                -- ["<leader>xL"] = {
                --     cmd = "<cmd>Trouble loclist toggle<cr>",
                -- },
                -- ["<leader>xQ"] = {
                --     cmd = "<cmd>Trouble qflist toggle<cr>",
                -- },
            }
        })
    }
}
