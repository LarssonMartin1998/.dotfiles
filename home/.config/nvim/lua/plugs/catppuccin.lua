return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato",
            background = {
                light = "latte",
                dark = "macchiato"
            },
            transparent_background = true,
            term_colors = true,
            sidebars = { "qf", "help" },
            integrations = {
                leap = true,
                lsp_saga = true,
                lsp_trouble = true,
                mason = true,
                semantic_tokens = true,
                treesitter_context = true,
                telescope = {
                    enable = true,
                },
                cmp = true,
                dap_ui = true,
                dap = true,
            },
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percent = 0.15,
            },
            styles = {
                comments = { "italic" },
            },
            custom_highlights = function(colors)
                return {
                    FloatBorder = { fg = colors.lavender },
                    CmpItemMenu = { fg = colors.overlay2 },
                    TelescopeNormal = { link = "NormalFloat" },
                    TelescopeSelection = { link = "NormalFloat" },
                    CopilotSuggestion = { fg = colors.overlay2 },
                }
            end
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
