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
            },
            implement = {
                enable = false,
            },
            outline = {
                enable = false,
                win_width = 52,
            },
            ui = {
                kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
                border = "single",
                title = false
            }
        })

        require("utils").add_keymaps({
            n = {
                ["]d"] = {
                    cmd = ":Lspsaga diagnostic_jump_prev<CR>"
                },
                ["[d"] = {
                    cmd = ":Lspsaga diagnostic_jump_next<CR>"
                },
                ["K"] = {
                    cmd = ":Lspsaga hover_doc<CR>"
                },
                ["<leader>rn"] = {
                    cmd = ":Lspsaga rename<CR>"
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
