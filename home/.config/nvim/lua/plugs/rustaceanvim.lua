return {
    "mrcjkb/rustaceanvim",
    version = "^4",
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
                    vim.lsp.inlay_hint.enable(bufnr, true)

                    if client.server_capabilities.documentFormattingProvider then
                        vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = 0 })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format()
                            end,
                        })
                    end

                    require("utils").add_keymaps({
                        n = {
                            ["gd"] = {
                                cmd = function()
                                    vim.lsp.buf.definition()
                                end,
                                opts = {
                                    noremap = true,
                                    silent = true
                                }
                            },
                            ["gD"] = {
                                cmd = function()
                                    vim.lsp.buf.declaration()
                                end,
                                opts = {
                                    noremap = true,
                                    silent = true
                                }
                            },
                        }
                    })
                end,
            }
        }
    end,
}
