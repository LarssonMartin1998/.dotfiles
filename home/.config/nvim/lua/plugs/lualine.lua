return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local catppuccin_theme = require("lualine.themes.catppuccin")
        local slightly_darker_surface0 = "#2c3045"
        catppuccin_theme.normal.c.bg = slightly_darker_surface0
        -- TODO: Change the colors of the lualine theme to match the statusbar from the catppuccin theme in zellij
        -- The lualine is already using the catppuccin theme, but the design is not consistent with the zellij statusbar ...
        -- Very nitpicky, but it would be nice to have a consistent design

        require("lualine").setup {
            options = {
                theme = catppuccin_theme,
                section_separators = { "", "" },
                component_separators = { "", "" },
                icons_enabled = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = {},
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
        }
    end
}
