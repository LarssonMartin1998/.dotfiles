local saved_hlsearch = false
local saved_highlights = {}
local colors = require("ayu.colors")
colors.generate(true)

local function save_and_set_invisible_inlay_hints_hl()
    saved_highlights = vim.api.nvim_get_hl_by_name("LspInlayHint", true)
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = colors.bg, bg = colors.bg })
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
    config = function()
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

        local leap_user = require("leap.user")
        local function leap_across_windows()
            leap.leap({
                target_windows = leap_user.get_focusable_windows()
            })
        end

        local function leap_in_current_buffer()
            leap.leap({
                target_windows = { vim.api.nvim_get_current_win() }
            })
        end

        utils.add_keymaps({
            n = {
                ["l"] = {
                    cmd = function()
                        leap_across_windows()
                    end,
                },
            },
            v = {
                ["l"] = {
                    cmd = function()
                        leap_in_current_buffer()
                    end,
                }
            },
            o = {
                ["l"] = {
                    cmd = function()
                        leap_in_current_buffer()
                    end,
                }
            }
        })
    end,
}
