return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("lualine").setup {
            options = {
                theme = "tokyonight",
                section_separators = {"", ""},
                component_separators = {"", ""},
                icons_enabled = true,
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch"},
                lualine_c = { "require(\"lualine_extension_lspsaga\").get_breadcrumbs()" },
                lualine_x = {"encoding", "fileformat", "filetype"},
                lualine_y = {"progress"},
                lualine_z = {"location"}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = {"location"},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
        }
    end
}
