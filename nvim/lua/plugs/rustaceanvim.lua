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
                    replace_builtin_hover = true,
                },
            },
            server = {
                on_attach = require("lsplib").configure_generic_client,
                default_settings = {
                    ["rust-analyzer"] = {
                        inlayHints = {
                            chainingHints = true,
                            parameterHints = true,
                            typeHints = true,
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true,
                            },
                        },
                    },
                },
            }
        }
    end,
}
