local buffers_without_inlay_hints = {}
local saved_hlsearch = false

local function set_inlay_hints_active(buffers, enable)
    for _, bufnr in pairs(buffers) do
        vim.lsp.inlay_hint.enable(enable, { burfnr = bufnr })
    end
end

local function get_open_buffers_with_inlay_hints()
    local buffers = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
            table.insert(buffers, bufnr)
        end
    end

    return buffers
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
                    local open_buffers = get_open_buffers_with_inlay_hints()
                    set_inlay_hints_active(open_buffers, false)
                    buffers_without_inlay_hints = open_buffers
                    saved_hlsearch = vim.o.hlsearch
                    vim.o.hlsearch = false
                end
            },
            {
                event_name = "LeapLeave",
                cb = function()
                    set_inlay_hints_active(buffers_without_inlay_hints, true)
                    vim.o.hlsearch = saved_hlsearch
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
        local leap_remote = require("leap.remote")
        utils.add_keymaps({
            n = {
                ["l"] = {
                    cmd = function()
                        -- Make sure we can Leap to any window
                        leap.leap({
                            target_windows = leap_user.get_focusable_windows()
                        })
                    end,
                },
                ["gl"] = {
                    cmd = function()
                        leap_remote.action()
                    end
                }
            },
            v = {
                ["l"] = {
                    cmd = function()
                        leap.leap({
                            target_windows = { vim.api.nvim_get_current_win() }
                        })
                    end,
                }
            },
            o = {
                ["l"] = {
                    cmd = function()
                        leap_remote.action()
                    end,
                }
            }
        })
    end,
}
