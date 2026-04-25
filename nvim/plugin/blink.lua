local function gh(repo)
    return "https://github.com/" .. repo
end

vim.api.nvim_create_autocmd("ModeChanged", {
    once = true,
    callback = function()
        vim.pack.add({
            gh("rafamadriz/friendly-snippets"),
            { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.x") },
            { src = gh("saghen/blink.cmp"), version = vim.version.range("1.x") },
            gh("xzbdmw/colorful-menu.nvim"),
        })

        require("blink.cmp").setup({
            keymap = { preset = "super-tab" },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = {
                    auto_show = false,
                },
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },
            snippets = {
                preset = "luasnip",
                active = function() return false end,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        })
        require("colorful-menu").setup({})

        local ls = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        ls.filetype_extend("typescriptreact", { "html" })
        ls.filetype_extend("javascriptreact", { "html" })
        ls.config.set_config({
            enable_autosnippets = false,
            store_selection_keys = false,
        })
    end,
})
