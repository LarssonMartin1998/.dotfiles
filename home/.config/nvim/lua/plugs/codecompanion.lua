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

        require("utils").add_keymaps({
            n = {
                ["<Leader>ci"] = { cmd = "<cmd>CodeCompanion<cr>" },
                ["<Leader>cc"] = { cmd = "<cmd>CodeCompanionChat toggle<cr>" },
                ["<Leader>cm"] = { cmd = "<cmd>CodeCompanion /commit<cr>" },
            },
            v = {
                ["<Leader>ci"] = { cmd = "<cmd>CodeCompanion<cr>" },
                ["ga"] = { cmd = "<cmd>CodeCompanionAdd<cr>" },
                ["<Leader>ce"] = { cmd = "<cmd>CodeCompanion /explain<cr>" },
                ["<Leader>cf"] = { cmd = "<cmd>CodeCompanion /fix<cr>" },
                ["<Leader>ct"] = { cmd = "<cmd>CodeCompanion /tests<cr>" },
            }
        })

        vim.cmd([[cab cc CodeCompanion]])
    end
}
