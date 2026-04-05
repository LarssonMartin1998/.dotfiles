local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

local is_debug_mode_active = false

local dap = require("dap")

require("nvim-dap-repl-highlights").setup({})
require("nvim-dap-virtual-text").setup({})
require("persistent-breakpoints").setup({ load_breakpoints_event = { "BufReadPost" } })
require("dapui").setup({
    controls = { enabled = false },
    layouts = {
        {
            elements = {
                { id = "watches", size = 0.5 },
                { id = "stacks",  size = 0.5 },
            },
            position = "bottom",
            size = 15,
        },
    },
})
require("dap-go").setup({})

dap.adapters.codelldb = require("dap.codelldb")

local virtual_text = require("nvim-dap-virtual-text/virtual_text")
local breakpoint_api = require("persistent-breakpoints.api")

local stepping_keymaps = {
    { "<F10>", function() dap.step_over() end },
    { "<F11>", function() dap.step_into() end },
    { "<F12>", function() dap.step_out() end },
    {
        "<leader>dc",
        function()
            require("dapui").float_element("console", {
                enter = true,
                title = "output",
                border = "rounded",
                position = "center",
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.6),
            })
        end,
    },
}

for _, sign in ipairs({
    { "DapBreakpoint",          { text = "🛑", texthl = "", linehl = "", numhl = "" } },
    { "DapBreakpointRejected",  { text = "🔵", texthl = "", linehl = "", numhl = "" } },
    { "DapBreakpointCondition", { text = "🟥", texthl = "", linehl = "", numhl = "" } },
}) do
    vim.fn.sign_define(unpack(sign))
end

local function enter_debug_mode()
    if is_debug_mode_active then return end
    utils.set_keymap_list(stepping_keymaps)
    is_debug_mode_active = true
    inlay_hints_handler.disable()
    require("dapui").open()
end

local function exit_debug_mode()
    if not is_debug_mode_active then return end
    utils.del_keymap_list(stepping_keymaps)
    is_debug_mode_active = false
    inlay_hints_handler.restore()
    virtual_text.clear_virtual_text()
    require("dapui").close()
end

for _, request in ipairs({ "attach", "launch" }) do
    dap.listeners.before[request]["dapui_config"] = enter_debug_mode
end

for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.after[event]["dapui_config"] = exit_debug_mode
end

local function dap_stop()
    dap.terminate()
    dap.close()
    exit_debug_mode()
end

utils.set_keymap_list({
    { "<leader>dr", dap.continue },
    { "<leader>bt", breakpoint_api.toggle_breakpoint },
    { "<leader>bc", breakpoint_api.set_conditional_breakpoint },
    { "<leader>br", breakpoint_api.clear_all_breakpoints },
    { "<leader>ds", dap_stop },
})

vim.api.nvim_create_user_command("LaunchTemplate", function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "{",
        '    "version": "0.2.0",',
        '    "configurations": [',
        "        {",
        '            "type": "codelldb",',
        '            "request": "launch",',
        '            "name": "Launch",',
        '            "program": "${workspaceFolder}/build/binary",',
        '            "cwd": "${workspaceFolder}",',
        '            "args": [],',
        '            "stopOnEntry": false,',
        '            "environment": []',
        "        }",
        "    ]",
        "}",
    })
end, {})
