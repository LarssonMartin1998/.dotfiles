local utils = require("utils")
local dap = require("dap")

local dir_path = "dap"
utils.foreach(utils.get_file_names_in_dir(dir_path, "*.lua", true), function(adapter)
    dap.adapters[adapter] = require(dir_path .. "/" .. adapter)
end)

vim.api.nvim_create_user_command("LaunchTemplate", function()
    local template = {
        '{',
        '    "version": "0.2.0",',
        '    "configurations": [',
        '        {',
        '            "type": "codelldb",',
        '            "request": "launch",',
        '            "name": "Launch",',
        '            "program": "${workspaceFolder}/build/binary",',
        '            "cwd": "${workspaceFolder}",',
        '            "args": [],',
        '            "stopOnEntry": false,',
        '            "environment": []',
        '        }',
        '    ]',
        '}',
    }

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template)
end, {})

-- Do not define default fallbacks until I have a better way of handling a default selected configuration.
-- I never want to be prompted for a configuration, we should have ae serialized active config which is always run unless changed.
-- -- Define configurations
-- dap.configurations.cpp = {
--     {
--         name = "Launch File",
--         type = "codelldb",
--         request = "launch",
--         program = function()
--             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--         end,
--         cwd = "${workspaceFolder}",
--         stopOnEntry = false,
--         args = {},
--     },
-- }
