local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")
local format_handler = require("format_handler")

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
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

        inlay_hints_handler.add_buffer(bufnr)

        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = 0 })
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    format_handler.format()
                end,
            })
        end

        utils.set_keymap_list({
            { "gd", function() vim.lsp.buf.definition({ reuse_win = true, }) end,  { noremap = true, buffer = bufnr } },
            { "gD", function() vim.lsp.buf.declaration({ reuse_win = true, }) end, { noremap = true, buffer = bufnr } },
        })
    end
})
