local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    -- Foundational
    gh("LarssonMartin1998/mini.nvim"),
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

    -- Colorscheme
    gh("rktjmp/lush.nvim"),
    gh("LarssonMartin1998/nvim-norrsken"),

    -- UI
    gh("nvim-lualine/lualine.nvim"),
    gh("b0o/incline.nvim"),

    -- Motions
    gh("mawkler/demicolon.nvim"),
    gh("nvim-treesitter/nvim-treesitter-textobjects"),

    -- Misc
    gh("OXY2DEV/markview.nvim"),
    gh("MunifTanjim/nui.nvim"),
    gh("rachartier/tiny-glimmer.nvim"),
})

vim.cmd.packadd("nvim.undotree")

vim.api.nvim_create_user_command("VimPackClean", function()
    local inactive_plugins = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    vim.notify("Attempting to delete inactive plugins: \n" .. table.concat(inactive_plugins, "\n"))
    if not pcall(vim.pack.del, inactive_plugins) then
        vim.notify("Failed to delete inactive plugins...")
    end
end, {})
