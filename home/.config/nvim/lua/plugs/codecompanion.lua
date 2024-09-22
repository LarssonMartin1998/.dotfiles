return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        { 'echasnovski/mini.diff',  version = false },
        { "stevearc/dressing.nvim", opts = {} },
    },
    config = function()
        require("codecompanion").setup({
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
        })
    end
}
