return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
        local fzf = require("fzf-lua")
        require("utils").add_keymaps({
            n = {
                ["<leader>to"] = {
                    cmd = function()
                        fzf.files({
                            git_icons = false,
                        })
                    end
                }
            }
        })
    end
}
