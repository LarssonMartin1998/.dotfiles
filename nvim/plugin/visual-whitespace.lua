vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:[vV\22]",
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/mcauley-penney/visual-whitespace.nvim" })
        require("visual-whitespace").setup({})
    end,
})
