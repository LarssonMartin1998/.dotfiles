return {
    "saghen/blink.cmp",
    lazy = false,
    version = "v0.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "super-tab" },

        -- highlight = {
        --     use_nvim_cmp_as_default = true,
        -- },
        -- nerd_font_variant = "mono",
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" }
}
