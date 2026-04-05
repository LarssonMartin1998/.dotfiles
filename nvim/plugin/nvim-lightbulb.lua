require("nvim-lightbulb").setup({
    hide_in_unfocused_buffer = true,
    code_lenses = false, -- 0.12 shows code lenses as virtual lines natively
    sign = { enabled = true },
    virtual_text = { enabled = false },
    float = { enabled = false },
    status_text = { enabled = false },
    autocmd = { enabled = true, updatetime = 25 },
})
