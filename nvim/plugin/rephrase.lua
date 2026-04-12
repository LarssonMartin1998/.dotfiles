vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/LarssonMartin1998/nvim-rephrase" })
        require("rephrase").setup({})
        require("utils").set_keymap_list({ { "<leader>h", "<cmd>Rephrase<cr>" } })
    end,
})
