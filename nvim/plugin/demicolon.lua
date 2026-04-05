vim.schedule(function()
    vim.pack.add({ "https://github.com/mawkler/demicolon.nvim" })
    require("demicolon").setup({
        keymaps = {
            repeat_motions = "stateful",
        },
    })
end)
