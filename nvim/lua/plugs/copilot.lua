return {
    "github/copilot.vim",
    config = function()
        vim.g.copilot_no_tab_map = true
        require("utils").add_keymaps({
            i = {
                ["<Right>"] = {
                    cmd = 'copilot#Accept("\\<Right>")',
                    opts = {
                        expr = true,
                        replace_keycodes = false,
                        silent = true,
                    }
                }
            }
        })
    end
}
