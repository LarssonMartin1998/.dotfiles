return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    lazy = true,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    after = "nvim-lspconfig",
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
                border = "rounded",
                title = false,
            },
            code_action = {
                extend_gitsigns = true
            }
        })

        local keymaps = {
            n = {
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
        }
        local utils = require("utils")
        utils.add_opts_to_all_mappings(keymaps, { silent = true })
        utils.add_keymaps(keymaps)
    end,
}
