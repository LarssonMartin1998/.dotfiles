return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            symbol_in_winbar = {
                enable = false,
                -- separator = " › ",
                -- hide_keyword = true,
                -- ignore_patterns = nil,
                -- show_file = true,
                -- folder_level = 2,
                -- color_mode = true,
                -- dely = 300,
                -- show_nodes = true,
                -- max_nodes = 2,
            },
            implement = {
                enable = false,
            },
            outline = {
                win_width = 52,
            },
            ui = {
                kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
                border = "single",
            }
        })

        require("utils").add_keymaps({
            n = {
                ["<F2>"] = {
                    cmd = ":Lspsaga diagnostic_jump_next<CR>"
                },
                ["<F3>"] = {
                    cmd = ":Lspsaga diagnostic_jump_prev<CR>"
                },
                ["K"] = {
                    cmd = ":Lspsaga hover_doc<CR>"
                },
                ["<leader>lo"] = {
                    cmd = ":Lspsaga outline<CR>"
                },
                ["<leader>rn"] = {
                    cmd = ":Lspsaga rename<CR>"
                },
                ["<leader>h"] = {
                    cmd = ":Lspsaga term_toggle<CR>"
                },
                ["gr"] = {
                    cmd = ":Lspsaga finder<CR>"
                },
                ["<leader>lt"] = {
                    cmd = ":Lspsaga peek_type_definition<CR>"
                },
                ["<leader>ld"] = {
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