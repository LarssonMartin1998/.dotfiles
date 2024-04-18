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
                mason = true,
                semantic_tokens = true,
                treesitter_context = true,
                telescope = {
                    enable = true,
                    -- style = "nvchad",
                },
                -- dap_ui = true,
                -- dap = true,
                -- Read catppuccin integration guide when installing dap, and dap_ui
                -- sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
                -- sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
                -- sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
            },
            on_highlights = function(hl, c)
                -- local prompt = "#2d3149"
                -- hl.TelescopeNormal = {
                --   bg = c.bg_dark,
                --   fg = c.fg_dark,
                -- }
                -- hl.TelescopeBorder = {
                --   bg = c.bg_dark,
                --   fg = c.bg_dark,
                -- }
                -- hl.TelescopePromptNormal = {
                --   bg = prompt,
                -- }
                -- hl.TelescopePromptBorder = {
                --   bg = prompt,
                --   fg = prompt,
                -- }
                -- hl.TelescopePromptTitle = {
                --   bg = prompt,
                --   fg = prompt,
                -- }
                -- hl.TelescopePreviewTitle = {
                --   bg = c.bg_dark,
                --   fg = c.bg_dark,
                -- }
                -- hl.TelescopeResultsTitle = {
                --   bg = c.bg_dark,
                --   fg = c.bg_dark,
                -- }
            end,
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
