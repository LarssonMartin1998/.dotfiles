return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        "telescope",
        winopts = {
            preview = {
                default = "bat"
            }
        },
        lsp = {
            workspace_symbols = {
                symbol_kinds = { "Variable", "Function", "Method", "Class", "Struct", "Interface" },
            },
        },
    },
    config = function()
        local fzf = require("fzf-lua")
        local pickers = {
            {
                mapping = "o",
                action = function()
                    fzf.files({
                        git_icons = false,
                    })
                end
            },
            {
                mapping = "a",
                action = function()
                    fzf.live_grep_native({
                        git_icons = false,
                        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case",
                        fzf_opts = {
                            ['--exact'] = false, -- Disable exact matching
                        },
                    })
                end
            },
            {
                mapping = "g",
                action = function()
                    fzf.git_bcommits({})
                end
            },
            {
                mapping = "s",
                action = function()
                    fzf.lsp_live_workspace_symbols({})
                end
            }
        }

        local keymaps = {}
        keymaps.n = {}
        for _, picker in ipairs(pickers) do
            keymaps.n["<leader>t" .. picker.mapping] = {
                cmd = picker.action
            }
        end

        require("utils").add_keymaps(keymaps)
    end
}
