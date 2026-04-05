vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    once = true,
    callback = function()
        vim.g.rustaceanvim = {
            inlay_hints = {
                highlight = "NonText",
            },
            tools = {
                hover_actions = {
                    auto_focus = true,
                    replace_builtin_hover = true,
                },
            },
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        inlayHints = {
                            chainingHints = true,
                            parameterHints = true,
                            typeHints = true,
                        },
                        diagnostics = {
                            enable = true,
                            experimental = { enable = true },
                        },
                    },
                },
            },
        }
        vim.pack.add({
            { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("5.x") },
        })
    end,
})
