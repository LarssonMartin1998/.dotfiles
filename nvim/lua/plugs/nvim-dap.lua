local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

local is_debug_mode_active = false
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "igorlfs/nvim-dap-view",               opts = {} },
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

        local dap_signs = {
            { "DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" } },
            { "DapBreakpointRejected", { text = "🔵", texthl = "", linehl = "", numhl = "" } },
            { "DapBreakpointCondition", { text = "🟥", texthl = "", linehl = "", numhl = "" } },
        }

        for _, sign in ipairs(dap_signs) do
            vim.fn.sign_define(unpack(sign))
        end

        local function enter_debug_mode()
            if is_debug_mode_active then
                return
            end

            utils.set_keymap_list(stepping_keymaps)
            is_debug_mode_active = true

            inlay_hints_handler.disable()
            require("dap-view").open()
        end

        local function exit_debug_mode()
            if not is_debug_mode_active then
                return
            end

            utils.del_keymap_list(stepping_keymaps)
            is_debug_mode_active = false
            require("leap_keymap_handler").set_leap_keymapping()

            inlay_hints_handler.restore()
            virtual_text.clear_virtual_text()
            require("dap-view").close()
        end

        for _, request in ipairs({
            { "attach", enter_debug_mode },
            { "launch", enter_debug_mode },
        }) do
            dap.listeners.before[request[1]]["dapview"] = request[2]
        end

        for _, event in ipairs({
            { "event_terminated", exit_debug_mode },
            { "event_exited",     exit_debug_mode },
        }) do
            dap.listeners.after[event[1]]["dapview"] = event[2]
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
    end,
}
