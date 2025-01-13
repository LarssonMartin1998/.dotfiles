local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

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
                                vim.lsp.buf.format()
                            end,
                        })
                    end

                    utils.add_keymaps({
                        n = {
                            ["gd"] = {
                                cmd = function()
                                    vim.lsp.buf.definition()
                                end,
                                opts = {
                                    noremap = true,
                                    silent = true,
                                    buffer = bufnr,
                                }
                            },
                            ["gD"] = {
                                cmd = function()
                                    vim.lsp.buf.declaration()
                                end,
                                opts = {
                                    noremap = true,
                                    silent = true,
                                    buffer = bufnr,
                                }
                            },
                        }
                    })
                end,
            }
        }
    end,
}
