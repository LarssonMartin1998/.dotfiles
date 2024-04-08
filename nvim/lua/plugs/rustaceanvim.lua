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
                on_attach = function(_, bufnr)
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end,
            }
        }
    end,
}
