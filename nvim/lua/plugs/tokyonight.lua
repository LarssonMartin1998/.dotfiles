return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "storm",
            light_style = "day",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = {},
                keywords = {},
                functions = {},
                variables = {},
                sidebars = "dark",
                floats = "dark"
            },
            sidebars = { "qf", "help" },
            day_brightness = 0.3,
            hide_inactive_statusline = false,
            dim_inactive = false,
            lualine_bold = true,

            --- You can override specific color groups to use other groups or a hex color
            --- function will be called with a ColorScheme table
            ---@param colors ColorScheme
            on_colors = function(colors) end,

            --- You can override specific highlights to use other groups or a hex color
            --- function will be called with a Highlights and ColorScheme table
            ---@param highlights Highlights
            ---@param colors ColorScheme
            on_highlights = function(highlights, colors)
                local prompt = "#2d3149"
                highlights.TelescopeNormal = {
                    bg = colors.bg_dark,
                    fg = colors.fg_dark,
                }
                highlights.TelescopeBorder = {
                    bg = colors.bg_dark,
                    fg = colors.bg_dark,
                }
                highlights.TelescopePromptNormal = {
                    bg = prompt,
                }
                highlights.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                highlights.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                highlights.TelescopePreviewTitle = {
                    bg = colors.bg_dark,
                    fg = colors.bg_dark,
                }
                highlights.TelescopeResultsTitle = {
                    bg = colors.bg_dark,
                    fg = colors.bg_dark,
                }
            end,
        })

        vim.cmd[[colorscheme tokyonight-storm]]
    end
}

-- Usecase example for other plugins when adding colorscheme support
--[[
local colors = require("tokyonight.colors").setup() -- pass in any of the config options as explained above
local util = require("tokyonight.util")

aplugin.background = colors.bg_dark
aplugin.my_error = util.lighten(colors.red1, 0.3) -- number between 0 and 1. 0 results in white, 1 results in red1
]]--
