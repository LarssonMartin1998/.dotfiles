local function add_new_custom_highlights()
    local colors = require("catppuccin.palettes.macchiato");
    local highlights = {
        { name = "EdgeTool",       config = { bg = colors.mantle, fg = colors.text } },
        { name = "EdgeToolBorder", config = { bg = colors.mantle, fg = colors.lavender } },
    }

    for _, highlight in ipairs(highlights) do
        vim.api.nvim_set_hl(0, highlight.name, highlight.config)
    end
end

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        add_new_custom_highlights()

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
                telescope = { -- This doesn't seem to be compatible when running the custom dropdown theme
                    enable = true
                },
                cmp = true,
                dap_ui = true,
                dap = true,
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

                    Pmenu = { link = "EdgeTool" },
                    PmenuSel = { bg = colors.overlay0 },

                    -- Telescope
                    TelescopeNormal = { link = "EdgeTool" },
                    TelescopeBorder = { link = "EdgeToolBorder" },
                    TelescopePromptNormal = { link = "EdgeTool" },
                    TelescopePromptBorder = { link = "EdgeToolBorder" },
                    TelescopeResultsNormal = { link = "EdgeTool" },
                    TelescopeResultsBorder = { link = "EdgeToolBorder" },
                    TelescopePreviewNormal = { link = "EdgeTool" },
                    TelescopePreviewBorder = { link = "EdgeToolBorder" },

                    -- Trouble
                    TroubleNormal = { link = "EdgeTool" },

                    -- Saga
                    SagaNormal = { link = "EdgeTool" },
                    SagaBorder = { link = "EdgeToolBorder" },

                    -- Mason
                    Mason = { link = "EdgeTool" },
                    MasonNormal = { link = "EdgeTool" },

                    -- Lazy
                    LazyNormal = { link = "EdgeTool" },
                }
            end
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
