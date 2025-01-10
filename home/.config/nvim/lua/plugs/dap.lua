local utils = require("utils")

local are_stepping_keymaps_active = false
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        { "nvim-neotest/nvim-nio", lazy = true },
        "LiadOz/nvim-dap-repl-highlights",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        {
            "LarssonMartin1998/nvim-dap-profiles",
            opts = {},
        },
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        require("persistent-breakpoints").setup {
            load_breakpoints_event = { "BufReadPost" }
        }
        require("dap-go").setup()

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
                utils.add_keymaps(stepping_keymaps)
                are_stepping_keymaps_active = true
            end
        end

        local function exit_debug_mode()
            dapui.close()
            if are_stepping_keymaps_active then
                utils.remove_keymaps(stepping_keymaps)
                are_stepping_keymaps_active = false
            end
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

        require("nvim-dap-repl-highlights").setup()
        require("nvim-dap-virtual-text").setup()

        local breakpoint_api = require("persistent-breakpoints.api")
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
