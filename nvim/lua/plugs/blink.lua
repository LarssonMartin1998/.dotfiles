return {
    "saghen/blink.cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            dependencies = { "rafamadriz/friendly-snippets", },
            config = function()
                local ls = require("luasnip")
                require("luasnip.loaders.from_vscode").lazy_load()

                ls.filetype_extend("typescriptreact", { "html" })
                ls.filetype_extend("javascriptreact", { "html" })

                ls.config.set_config({
                    enable_autosnippets = false,
                    store_selection_keys = false,
                })
            end
        },
    },
    version = "1.*",
    opts = {
        keymap = { preset = "super-tab" },

        appearance = {
            nerd_font_variant = "mono"
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        snippets = {
            preset = "luasnip",
            -- Disable snippet navigation while keeping expansion
            active = function() return false end,
        },
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "snippets", "buffer", },
            per_filetype = {
                codecompanion = { "codecompanion", },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" },
}
