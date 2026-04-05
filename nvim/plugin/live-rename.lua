vim.schedule(function()
    vim.pack.add({ "https://github.com/saecki/live-rename.nvim" })
    require("live-rename").setup({
        prepare_rename = true,
        request_timeout = 1500,
        show_other_ocurrences = true,
        use_patterns = true,
        scratch_register = "l",
        keys = {
            submit = {
                { "n", "<cr>" },
                { "v", "<cr>" },
                { "i", "<cr>" },
            },
            cancel = {
                { "n", "<esc>" },
                { "n", "q" },
            },
        },
        hl = {
            current = "CurSearch",
            others = "Search",
        },
    })
    vim.keymap.set("n", "<leader>r", function()
        require("live-rename").rename({ cursorpos = 0 })
    end)
end)
