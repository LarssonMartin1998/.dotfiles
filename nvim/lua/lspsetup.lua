local utils = require("utils")
local lsplib = require("lsplib")

vim.lsp.config("*", {
    root_markers = { ".git" },
})

local servers = {}
utils.foreach(utils.get_file_names_in_dir("../lsp", "*.lua", true), function(server_name)
    table.insert(servers, server_name)
end)

vim.lsp.enable(servers)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        assert(client, "LspAttach: client is nil")

        lsplib.configure_generic_client(client, bufnr)
    end
})
