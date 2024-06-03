return {
    "mbbill/undotree",
    config = function()
        require("utils").add_keymaps({
            n = {
                ["<leader>ud"] = { cmd = ":UndotreeToggle<CR>" }
            }
        })
    end
}
