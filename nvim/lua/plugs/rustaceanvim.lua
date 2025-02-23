local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")
local format_handler = require("format_handler")

return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            inlay_hints = {
                highlight = "NonText",
            },
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
            },
            server = {
                on_attach = function(client, bufnr)
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
                end,
            }
        }
    end,
}
