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
                lsp_saga = true,
                lsp_trouble = true,
                mason = true,
                semantic_tokens = true,
                treesitter_context = true,
                telescope = { -- This doesn't seem to be compatible when running the custom dropdown theme
                    enable = true
                },
                cmp = true,
                dap_ui = true,
                dap = true,
                notify = true,
            },
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percent = 0.15,
            },
            styles = {
                comments = { "italic" },
            },
            custom_highlights = function(colors)
                return {
                    FloatBorder = { fg = colors.surface0 },
                    CmpItemMenu = { fg = colors.overlay2 },
                    CopilotSuggestion = { fg = colors.overlay2 },

                    -- Saga
                    ActionPreviewTitle = { bg = colors.mantle },

                    -- Leap
                    LeapLabelPrimary = { bg = colors.green, fg = colors.base },
                    LeapBackdrop = { link = "Comment" },
                }
            end
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
