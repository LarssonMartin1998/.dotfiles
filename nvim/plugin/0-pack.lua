local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    -- Mini suite
    gh("LarssonMartin1998/mini.nvim"),

    -- Colorscheme
    gh("rktjmp/lush.nvim"),
    gh("LarssonMartin1998/nvim-norrsken"),

    -- Treesitter
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    gh("nvim-treesitter/nvim-treesitter-context"),
    gh("nvim-treesitter/nvim-treesitter-textobjects"),

    -- Completion
    gh("rafamadriz/friendly-snippets"),
    { src = gh("L3MON4D3/LuaSnip"),                version = vim.version.range("2.x") },
    { src = gh("saghen/blink.cmp"),                version = vim.version.range("1.x") },

    -- UI
    gh("nvim-lualine/lualine.nvim"),
    gh("b0o/incline.nvim"),
    gh("kosayoda/nvim-lightbulb"),
    gh("rachartier/tiny-glimmer.nvim"),
    gh("rachartier/tiny-inline-diagnostic.nvim"),

    -- DAP
    gh("mfussenegger/nvim-dap"),
    gh("rcarriga/nvim-dap-ui"),
    gh("nvim-neotest/nvim-nio"),
    gh("LiadOz/nvim-dap-repl-highlights"),
    gh("theHamsta/nvim-dap-virtual-text"),
    gh("Weissle/persistent-breakpoints.nvim"),
    gh("leoluz/nvim-dap-go"),

    -- Misc
    gh("OXY2DEV/markview.nvim"),
    gh("MunifTanjim/nui.nvim"),
    gh("xzbdmw/colorful-menu.nvim"),
})

require("colorful-menu").setup({})

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
