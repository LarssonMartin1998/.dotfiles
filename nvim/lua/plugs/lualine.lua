local function resize_mode()
    if require("window_management").is_in_resizing_mode() then
        return "▲ Resizing ▼ "
    else
        return " "
    end
end

local tabs = {
    "tabs",
    use_mode_colors = true,
    tabs_color = {
        active = "lualine_b_command",
    },
    show_modified_status = false,
    component_separators = {
        left = "",
        right = ""
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    event = "VeryLazy",
    lazy = true,
    opts = {
        options = {
            theme = "ayu",
            globalstatus = true,
            section_separators = {
                left = "",
                right = "",
            },
            component_separators = {
                left = "",
                right = ""
            },
            icons_enabled = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                {
                    "diagnostics",
                    sources = { "nvim_lsp" },
                    sections = { "error", "warn", "info", "hint" },
                    update_in_insert = false,
                },
                resize_mode,
            },
            lualine_c = { tabs },
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
}
