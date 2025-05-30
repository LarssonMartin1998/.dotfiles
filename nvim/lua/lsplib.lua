local inlay_hints_handler = require("inlay_hints_handler")
local format_handler = require("format_handler")
local utils = require("utils")

local lsp = vim.lsp.buf
local api = vim.api

local M = {}

function M.configure_generic_client(client, bufnr)
    inlay_hints_handler.add_buffer(bufnr)

    if client.server_capabilities.documentFormattingProvider then
        api.nvim_buf_create_user_command(bufnr, "Format", lsp.format, { nargs = 0 })
        api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                format_handler.format()
            end,
        })
    end

    -- Built-in LSP completion.
    -- Could switch to this if they just appeared automatically when typing, and didn't
    -- only rely on showing when the servers completionCharacters are typed.
    -- if client:supports_method("textDocument/completion") then
    --     vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end

    for mode, keys in pairs({
        n = {
            { "K",         function() lsp.hover() end,       { buffer = bufnr } },
            { "<leader>r", function() lsp.rename() end,      { buffer = bufnr } },
            { "<leader>a", function() lsp.code_action() end, { buffer = bufnr } },
        },
        i = {
            { "<C-s>", function() lsp.signature_help() end, { buffer = bufnr } },
        },
    }) do
        utils.set_keymap_list(keys, mode)
    end
end

return M
