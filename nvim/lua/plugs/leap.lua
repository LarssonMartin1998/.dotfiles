local saved_hlsearch = false
local saved_highlights = {}

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

local function save_and_set_invisible_inlay_hints_hl()
    saved_highlights = vim.api.nvim_get_hl(0, { name = "LspInlayHint" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = require("colors").get().bg, bg = "none" })
end

local function restore_inlay_hints_hl()
    vim.api.nvim_set_hl(0, "LspInlayHint", saved_highlights)
end

return {
    "ggandor/leap.nvim",
    dependencies = {
        { "tpope/vim-repeat", lazy = true },
    },
    event = "VeryLazy",
    lazy = true,
    opts = {},
    init = function()
        local leap = require("leap")

        -- Disable auto jumping to the first match
        -- Autojumping is not intuitive when running bi-directional leaps
        leap.opts.safe_labels = {}
        -- Adding more labels since we're not using autojumping. These are sorted by priority
        -- focusing on the home row and the strongest fingers for Colemak-DH
        leap.opts.labels = "tsragneiomdch,pfluxzv./kwqby;j1234567890{}()[]<>J!@#$%^&*TSRAGNEIOMDCHPFLUXZV?KWQBY:"

        local autocmds = {
            {
                event_name = "LeapEnter",
                cb = function()
                    saved_hlsearch = vim.o.hlsearch
                    vim.o.hlsearch = false
                    save_and_set_invisible_inlay_hints_hl()
                end
            },
            {
                event_name = "LeapLeave",
                cb = function()
                    vim.o.hlsearch = saved_hlsearch
                    restore_inlay_hints_hl()
                end
            },
        }

        local utils = require("utils")
        local leap_augroup_name = "LeapEvents"
        vim.api.nvim_create_augroup(leap_augroup_name, { clear = true })
        for _, cmd in ipairs(autocmds) do
            utils.create_user_event_cb(cmd.event_name, cmd.cb, leap_augroup_name)
        end

        require("utils").foreach({
            { "n", "m", normal_mode_leap },
            { "v", "m", leap_in_current_buffer },
            { "o", "m", leap_in_current_buffer }
        }, function(mapping)
            vim.keymap.set(mapping[1], mapping[2], mapping[3])
        end)
    end,
}
