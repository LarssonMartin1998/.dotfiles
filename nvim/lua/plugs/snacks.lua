return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        gitbrowse = {
            enabled = true,
            what = "branch",
        },
        picker = { enabled = true, },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
        debug = { enabled = true, },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        input = { enabled = true, },
        notifier = { enabled = true, },
        quickfile = { enabled = true, },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 5, total = 500 },
                easing = "outCirc",
            },
            animate_repeat = {
                delay = 100,
                duration = { step = 3, total = 50 },
                easing = "outCirc",
            },
        },
        words = {
            enabled = true,
            debounce = 100,
        },
        zen = {
            enabled = true,
            toggles = { dim = false, },
            on_open = function()
                _G["snacks_zen_mode"] = true
            end,
            on_close = function()
                _G["snacks_zen_mode"] = false
            end,
        },
    },
    keys = {
        { "gB",         function() Snacks.gitbrowse() end, },

        { "<leader>z",  function() Snacks.zen() end, },

        { "<leader>to", function() Snacks.picker.smart() end, },
        { "<leader>ta", function() Snacks.picker.grep() end, },
        { "<leader>tg", function() Snacks.picker.git_log_file() end, },
        { "<leader>ts", function() Snacks.picker.lsp_workspace_symbols() end, },
        { "<leader>tn", function() Snacks.picker.notifications() end },

        { "<leader>fr", function() Snacks.rename.rename_file({}) end },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                _G.inspect = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.backtrace = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.inspect
            end,
        })
    end
}
