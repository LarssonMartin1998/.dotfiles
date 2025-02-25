local utils = require("utils")
local M = {}
M.format_on_save = true

function M.format(force)
    local do_force = force or false
    if M.format_on_save or do_force then
        vim.lsp.buf.format()
    end
end

function M.format_enable()
    M.format_on_save = true
end

function M.format_disable()
    M.format_on_save = false
end

function M.setup()
    local user_commands = {
        { "FormatEnable",  "lua require('format_handler').format_enable()" },
        { "FormatDisable", "lua require('format_handler').format_disable()" },
    }
    for _, cmd in ipairs(user_commands) do
        vim.api.nvim_command("command! " .. cmd[1] .. " " .. cmd[2])
    end

    utils.set_keymap_list({
        { "<leader>ff", function() M.format() end },
        { "<leader>fe", function() M.format_enable() end },
        { "<leader>fd", function() M.format_disable() end },
    })
end

return M
