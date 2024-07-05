local buffers_without_inlay_hints = {}
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
        "tpope/vim-repeat",
    },
    config = function()
        local leap = require("leap")
        leap.opts.safe_labels = {}

        local autocmds = {
            {
                event_name = "LeapEnter",
                cb = function()
                    local open_buffers = get_open_buffers_with_inlay_hints()
                    set_inlay_hints_active(open_buffers, false)
                    buffers_without_inlay_hints = open_buffers
                end
            },
            {
                event_name = "LeapLeave",
                cb = function()
                    set_inlay_hints_active(buffers_without_inlay_hints, true)
                end
            },
        }

        local utils = require("utils")
        local leap_augroup_name = "LeapEvents"
        vim.api.nvim_create_augroup(leap_augroup_name, { clear = true })
        for _, cmd in ipairs(autocmds) do
            utils.create_user_event_cb(cmd.event_name, cmd.cb, leap_augroup_name)
        end

        require("utils").add_keymaps({
            n = {
                ["l"] = {
                    cmd = function()
                        require("leap").leap({ target_windows = require("leap.user").get_focusable_windows() })
                    end,
                }
            }
        })
    end,
}
