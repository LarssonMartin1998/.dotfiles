local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

local are_stepping_keymaps_active = false
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            opts = {
                controls = {
                    enabled = false,
                },
                layouts = {
                    {
                        elements = {
                            {
                                id = "watches",
                                size = 0.5
                            },
                            {
                                id = "stacks",
                                size = 0.5
                            }
                        },
                        position = "bottom",
                        size = 15
                    }
                },
            },
        },
        -- Special adapters
        { "leoluz/nvim-dap-go",                  opts = {} },
        { "mfussenegger/nvim-dap-python", },

        { "nvim-neotest/nvim-nio",               lazy = true },
        { "LiadOz/nvim-dap-repl-highlights",     opts = {} },
        { "theHamsta/nvim-dap-virtual-text",     opts = {} },
        { "Weissle/persistent-breakpoints.nvim", opts = { load_breakpoints_event = { "BufReadPost" } } },
    },
    config = function()
        local dap = require("dap")

        require("dap-python").setup("python3")
        require("dap.ext.vscode").load_launchjs()
        local virtual_text = require("nvim-dap-virtual-text/virtual_text")
        local breakpoint_api = require("persistent-breakpoints.api")

        local stepping_keymaps = {
            { "m", function() dap.step_out() end },
            { "n", function() dap.step_over() end },
            { "i", function() dap.step_into() end },
        }

        local function enter_debug_mode()
            require("dapui").open()
            if not are_stepping_keymaps_active then
                utils.set_keymap_list(stepping_keymaps)
                are_stepping_keymaps_active = true
            end

            inlay_hints_handler.disable()
        end

        local function exit_debug_mode()
            require("dapui").close()
            if are_stepping_keymaps_active then
                utils.del_keymap_list(stepping_keymaps)
                are_stepping_keymaps_active = false
            end

            inlay_hints_handler.restore()
            virtual_text.clear_virtual_text()
        end

        local dap_signs = {
            { "DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" } },
            { "DapBreakpointRejected", { text = "🔵", texthl = "", linehl = "", numhl = "" } },
            { "DapBreakpointCondition", { text = "🟥", texthl = "", linehl = "", numhl = "" } },
        }

        for _, sign in ipairs(dap_signs) do
            vim.fn.sign_define(unpack(sign))
        end

        dap.listeners.after.event_initialized["dapui_config"] = function()
            enter_debug_mode()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            exit_debug_mode()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            exit_debug_mode()
        end

        local function dap_stop()
            dap.disconnect({ terminateDebuggee = true })
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
    end,
}
