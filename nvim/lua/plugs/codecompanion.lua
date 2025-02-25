return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            chat = {
                adapter = "copilot",
            },
            inline = {
                adapter = "copilot",
            },
            agent = {
                adapter = "copilot",
            },
        },
        adapters = {
            copilot = function() return require("codecompanion.adapters").extend("copilot", {}) end,
        },
        display = {
            diff = {
                provider = "mini_diff",
            },
        },
        opts = {
            log_level = "DEBUG",
        },
    },
    keys = {
        { "<Leader>ci", "<cmd>CodeCompanion<cr>" },
        { "<Leader>cc", "<cmd>CodeCompanionChat toggle<cr>" },
        { "<Leader>ce", "<cmd>CodeCompanion /explain<cr>",  mode = "v" },
    },
    init = function()
        vim.cmd([[cab cc CodeCompanion]])
    end
}
