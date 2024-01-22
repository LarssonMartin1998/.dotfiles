local function create_tokyonight_storm_preset()
    local darken = require("tokyonight.util").darken

    local red = "#f7768e"
    local green = "#9ece6a"
    local yellow = "#e0af68"
    local blue = "#7aa2f7"
    local pink = "#bb9af7"
    local teal = "#7dcfff"

    return {
        name = "tokyonight-storm",
        init = function()
            vim.opt.guicursor:append({ "a:MyCursor" })
        end,
        skip = function()
            -- return true if we want to avoid applying highight for this mode, it's called on each mode change
            return false
        end,
        modes = {
            n = {
                winhl = {
                    CursorLineNr = { fg = blue },
                    CursorLine = { bg = darken(blue, 0.25) },
                },
                hl = {
                    MyCursor = { bg = darken(blue, 0.7) }
                }
            },
            no = {
                winhl = {},
                hl = {},
                operators = {
                    d = {
                        winhl = {
                            CursorLineNr = { fg = red },
                            CursorLine = { bg = darken(red, 0.15) },
                        },
                        hl = {
                            MyCursor = { bg = red }
                        }
                    },
                    y = {
                        winhl = {
                            CursorLineNr = { fg = yellow },
                            CursorLine = { bg = darken(yellow, 0.15) },
                        },
                        hl = {
                            MyCursor = { bg = yellow }
                        }
                    },
                    c = {
                        winhl = {
                            CursorLineNr = { fg = teal },
                            CursorLine = { bg = darken(teal, 0.15) },
                        },
                        hl = {
                            MyCursor = { bg = teal }
                        },
                    },
                },
            },
            i = {
                winhl = {
                    CursorLineNr = { fg = green },
                    CursorLine = { bg = darken(green, 0.125) },
                },
                hl = {
                    MyCursor = { bg = green }
                }
            },
            [{ "v", "V", "\x16" }] = {
                winhl = {
                    CursorLineNr = { fg = pink },
                    Visual = { bg = darken(pink, 0.3) },
                },
                hl = {
                    MyCursor = { bg = pink }
                }
            },
        },
    }
end

return {
    "rasulomaroff/reactive.nvim",
    config = function()
        local reactive = require("reactive")
        reactive.add_preset(create_tokyonight_storm_preset())
    end,
}
