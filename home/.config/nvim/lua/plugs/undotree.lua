return {
    "mbbill/undotree",
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("utils").add_keymaps({
            n = {
                ["<leader>ud"] = { cmd = ":UndotreeToggle<CR>", opts = { silent = true } }
            }
        })
    end
}
