local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

local are_stepping_keymaps_active = false
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",

        -- Special adapters
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",

        { "nvim-neotest/nvim-nio", lazy = true },
        "LiadOz/nvim-dap-repl-highlights",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        -- Special adapters
        require("dap-go").setup()
        require("dap-python").setup("python3")
        -- Special adapters

        require("dap.ext.vscode").load_launchjs()
        require("persistent-breakpoints").setup {
            load_breakpoints_event = { "BufReadPost" }
        }

        require("nvim-dap-repl-highlights").setup()
        require("nvim-dap-virtual-text").setup()
        local virtual_text = require("nvim-dap-virtual-text/virtual_text")
        local breakpoint_api = require("persistent-breakpoints.api")

        dapui.setup({
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
        })

        local stepping_keymaps = {
            n = {
                ["m"] = {
                    cmd = function()
                        dap.step_out()
                    end
                },
                ["n"] = {
                    cmd = function()
                        dap.step_over()
                    end
                },
                ["i"] = {
                    cmd = function()
                        dap.step_into()
                    end
                },
            }
        }

        local function enter_debug_mode()
            dapui.open()
            if not are_stepping_keymaps_active then
                utils.add_temporary_keymaps(stepping_keymaps)
                are_stepping_keymaps_active = true
            end

            inlay_hints_handler.disable()
        end

        local function exit_debug_mode()
            dapui.close()
            if are_stepping_keymaps_active then
                utils.remove_keymaps(stepping_keymaps)
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

        utils.add_keymaps({
            n = {
                ["<leader>dr"] = {
                    cmd = function()
                        dap.continue()
                    end
                },
                ["<leader>bt"] = {
                    cmd = function()
                        breakpoint_api.toggle_breakpoint()
                    end
                },
                ["<leader>bc"] = {
                    cmd = function()
                        breakpoint_api.set_conditional_breakpoint()
                    end
                },
                ["<leader>br"] = { -- breakpoint remove
                    cmd = function()
                        breakpoint_api.clear_all_breakpoints()
                    end
                },
                ["<leader>ds"] = {
                    cmd = function()
                        dap.disconnect({ terminateDebuggee = true })
                        dap.close()
                        exit_debug_mode()
                    end
                },
            }
        })
    end,
}
