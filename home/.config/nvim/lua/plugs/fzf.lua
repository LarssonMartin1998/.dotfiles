return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        "telescope",
        winopts = {
            preview = {
                default = "bat"
            }
        }
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
