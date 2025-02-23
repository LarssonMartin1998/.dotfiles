return {
    -- "nvimdev/lspsaga.nvim",
    "LarssonMartin1998/lspsaga.nvim", -- Use my own fork until PR's are merged
    event = "LspAttach",
    lazy = true,
    -- dir = "~/dev/git/lspsaga.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        request_timeout = 750,
        symbol_in_winbar = {
            enable = false,
        },
        implement = {
            enable = false,
        },
        outline = {
            enable = false,
            win_width = 52,
        },
        ui = {
            border = "rounded",
            title = false,
        },
        code_action = {
            extend_gitsigns = true
        },
        hover = {
            jump_on_first_press = true
        },
    },
    keys = {
        { "K",          ":Lspsaga hover_doc<CR>",            silent = true, },
        { "<leader>rn", ":Lspsaga rename<CR>",               silent = true, },
        { "gr",         ":Lspsaga finder<CR>",               silent = true, },
        { "<leader>lt", ":Lspsaga peek_type_definition<CR>", silent = true, },
        { "<leader>ld", ":Lspsaga peek_definition<CR>",      silent = true, },
        { "<leader>ca", ":Lspsaga code_action<CR>",          silent = true, },
        { "<leader>lc", ":Lspsaga incoming_calls<CR>",       silent = true, },
    },
}
