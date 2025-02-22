return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        gitbrowse = { enabled = true, },
        picker = { enabled = true, },
        dashboard = { enabled = true, },
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
                duration = { step = 7, total = 250 },
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
            toggles = { dim = false, }
        },
    },
    keys = {
        { "<leader>z",  function() Snacks.zen() end, },

        { "<leader>to", function() Snacks.picker.smart() end, },
        { "<leader>ta", function() Snacks.picker.grep() end, },
        { "<leader>tg", function() Snacks.picker.git_log_file() end, },
        { "<leader>ts", function() Snacks.picker.lsp_workspace_symbols() end, },
        { "<leader>tn", function() Snacks.picker.notifications() end },
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
