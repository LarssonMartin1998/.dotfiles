return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "RubixDev/mason-update-all",
    },
    config = function()
        -- Missing Rust because rust-analyzer is deprecated, and rustaceanvim is not included in mason yet, so it needs a custom setup.
        -- Make sure that these are named according to lspconfig and not mason packages
        local servers_names = {
            "lua_ls",
        }

        require("mason").setup()
        require("mason-lspconfig").setup()
        require("mason-tool-installer").setup({
            ensure_installed = servers_names,
        })
        require("mason-update-all").setup()

        -- Iterate each server and setup
        local lspconfig = require("lspconfig")
        for _, server_name in ipairs(servers_names) do
            local server = lspconfig[server_name]
            if server then
                server.setup(require("lua/language_servers/" .. server_name))
            else
                error("LSP server not found: " .. server_name)
            end

        end
    end,
}
