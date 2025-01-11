local utils = require("utils")
local dap = require("dap")

--[[
.vscode/launch.json:
----------------------------
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "name_of_adapter",
            "request": "launch/attach",
            "name": "Friendly name",
            "program": "${workspaceFolder}/path/to/executable",
            "cwd": "${workspaceFolder}",
            "args": [],
            "stopOnEntry": false,
            "environment": []
        }
    ]
}
----------------------------
]]

local dir_path = "dap/adapters"
utils.foreach(utils.get_file_names_in_dir(dir_path, "*.lua", true), function(adapter)
    dap.adapters[adapter] = require(dir_path .. "/" .. adapter)
end)

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
