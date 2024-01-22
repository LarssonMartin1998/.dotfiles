return {
    "LarssonMartin1998/lspsaga.nvim",
    branch = "improved_winbar",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            symbol_in_winbar = {
                enable = false,
                separator = " › ",
                hide_keyword = true,
                ignore_patterns = nil,
                show_file = true,
                folder_level = 3,
                color_mode = true,
                dely = 300,
                show_nodes = true,
                max_nodes = 3,
            },
            implement = {
                enable = false,
            },
            outline = {
                win_width = 52,
            },
            ui = {
                border = "none",
            }
        })

        require("utils").add_keymaps({
            n = {
                ["<F2>"] = {
                    cmd = ":Lspsaga diagnostic_jump_next<CR>"
                },
                ["<S-F2>"] = {
                    cmd = ":Lspsaga diagnostic_jump_prev<CR>"
                },
                ["K"] = {
                    cmd = ":Lspsaga hover_doc<CR>"
                },
                ["<leader>lo"] = {
                    cmd = ":Lspsaga outline<CR>"
                },
                ["<leader>lr"] = {
                    cmd = ":Lspsaga rename<CR>"
                },
                ["<leader>h"] = {
                    cmd = ":Lspsaga term_toggle<CR>"
                },
                ["<leader>lf"] = {
                    cmd = ":Lspsaga finder<CR>"
                },
                ["<leader>lpt"] = {
                    cmd = ":Lspsaga peek_type_definition<CR>"
                },
                ["<leader>lph"] = {
                    cmd = ":Lspsaga peek_definition<CR>"
                },
                ["<leader>ca"] = {
                    cmd = ":Lspsaga code_action<CR>"
                },
                ["<leader>lc"] = {
                    cmd = ":Lspsaga incoming_calls<CR>"
                },
            }
        })
    end,
}
