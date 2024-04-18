return {
    "stevearc/oil.nvim",
    config = function()
        local oil = require("oil")
        oil.setup()

        require("utils").add_keymaps({
            n = {
                ["<leader>o"] = {
                    cmd = function()
                        oil.toggle_float(vim.fn.getcwd())
                    end,
                }
            }
        })
    end,
}
