return {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
        vim.g.copilot_no_tab_map = true
    end,
    keys = {
        {
            "<Right>",
            'copilot#Accept("\\<Right>")',
            mode = "i",
            expr = true,
            replace_keycodes = false,
            silent = true,
            desc = "Copilot Accept with <Right>",
        },
    },
}
