local buffers_without_inlay_hints = {}
local function set_inlay_hints_active(buffers, enable)
    for _, bufnr in pairs(buffers) do
        vim.lsp.inlay_hint.enable(bufnr, enable)
    end
end

local function get_open_buffers_with_inlay_hints()
    local buffers = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        if vim.lsp.inlay_hint.is_enabled(bufnr) then
            table.insert(buffers, bufnr)
        end
    end

    return buffers
end

local function add_leap_autocmd(pattern, callback)
    vim.api.nvim_create_autocmd("User", {
        pattern = pattern,
        callback = function()
            callback()
        end,
    })
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
                pattern = "LeapEnter",
                cb = function()
                    local open_buffers = get_open_buffers_with_inlay_hints()
                    set_inlay_hints_active(open_buffers, false)
                    buffers_without_inlay_hints = open_buffers
                end
            },
            {
                pattern = "LeapLeave",
                cb = function()
                    set_inlay_hints_active(buffers_without_inlay_hints, true)
                end
            },
        }

        for _, cmd in ipairs(autocmds) do
            add_leap_autocmd(cmd.pattern, cmd.cb)
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
