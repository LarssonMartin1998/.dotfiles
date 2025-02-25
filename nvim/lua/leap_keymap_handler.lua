local M = {}

local function leap_across_windows()
    require("leap").leap({
        target_windows = require("leap.user").get_focusable_windows()
    })
end

local function leap_in_current_buffer()
    require("leap").leap({
        target_windows = { vim.api.nvim_get_current_win() }
    })
end

local function normal_mode_leap()
    if _G["snacks_zen_mode"] then
        leap_in_current_buffer()
    else
        leap_across_windows()
    end
end

function M.set_leap_keymapping()
    require("utils").foreach({
        { "n", "m", normal_mode_leap },
        { "v", "m", leap_in_current_buffer },
        { "o", "m", leap_in_current_buffer }
    }, function(mapping)
        vim.keymap.set(mapping[1], mapping[2], mapping[3])
    end)
end

return M
