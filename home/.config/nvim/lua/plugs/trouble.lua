local wm = require("window_management")

local is_trouble_window = false

-- It seems like Trouble doesn't open up the window instantly when calling
-- the toggle/open function, or when calling it by the command. This is a workaround
-- to get the window autosizing working properly, when we tried to run it directly
-- afterwards it would autosize before the window was actually opened.
local function setup_autosize_callback()
    local auname = "TroubleWinEnter"
    local augroup = vim.api.nvim_create_augroup(auname, { clear = true })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function()
            if not is_trouble_window then
                return
            end

            is_trouble_window = false
            wm.autosize_windows()
        end,
    })
end

return {
    "folke/trouble.nvim",
    event = "VeryLazy",
    lazy = true,
    config = function()
        local trouble = require("trouble")
        trouble.setup({})

        local utils = require("utils")
        setup_autosize_callback()

        local function toggle_trouble_mode(mode_to_toggle)
            is_trouble_window = true
            trouble.toggle({
                mode = mode_to_toggle,
                focus = true,
            })
        end

        local commands = {
            {
                keys = "x",
                mode = "diagnostics"
            },
            {
                keys = "ll",
                mode = "loclist"
            },
            {
                keys = "lq",
                mode = "quickfix"
            },
        }

        local keymaps = { n = {} }
        for _, command in ipairs(commands) do
            keymaps.n["<leader>" .. command.keys] = {
                cmd = function()
                    toggle_trouble_mode(command.mode)
                end,
                opts = { silent = true }
            }
        end
        utils.add_keymaps(keymaps)
    end
}
