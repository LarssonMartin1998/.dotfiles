return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "RubixDev/mason-update-all",
    },
    config = function()
        -- Find all files in lua/language_servers and require them
        -- We use them to ensure that the servers are installed and configured
        -- Make sure that the files use the lspconfig naming convention
        local lua_files_str = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/language_servers", "*.lua", true)
        local has_line_breaks = vim.fn.match(lua_files_str, [[\n]]) > -1
        -- Get an array of all the files in the directory, make sure to account for single file
        local lua_files = has_line_breaks and vim.fn.split(lua_files_str, "\n") or { lua_files_str }
        -- Remove path and extension and only keep the filename
        local server_names = vim.tbl_map(function(file)
            return vim.fn.fnamemodify(file, ":t:r")
        end, lua_files)

        require("mason").setup()
        require("mason-lspconfig").setup()
        require("mason-tool-installer").setup({
            ensure_installed = server_names,
        })
        require("mason-update-all").setup()

        -- Iterate each server and setup
        local lspconfig = require("lspconfig")
        for _, server_name in ipairs(server_names) do
            local server = lspconfig[server_name]
            if server then
                server.setup(require("language_servers/" .. server_name))
            else
                error("LSP server not found: " .. server_name)
            end
        end
    end,
}
