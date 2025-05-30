return {
    "olimorris/codecompanion.nvim", -- The KING of AI programming
    dependencies = {
        "echasnovski/mini.diff",
    },
    opts = {
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {
                        model = {
                            default = "claude-3.7-sonnet",
                        },
                    },
                })
            end,
            gemini = function()
                return require("codecompanion.adapters").extend("gemini", {
                    schema = {
                        model = {
                            default = "gemini-2.5-pro-exp-03-25",
                        },
                    },
                })
            end,
            openai = function()
                return require("codecompanion.adapters").extend("openai", {
                    opts = {
                        stream = true,
                    },
                    schema = {
                        model = {
                            default = function()
                                return "gpt-4o"
                            end,
                        },
                    },
                })
            end,
        },
        strategies = {
            chat = {
                adapter = "copilot",
                roles = {
                    user = "Martin",
                },
                slash_commands = {
                    ["buffer"] = {
                        opts = {
                            keymaps = {
                                modes = {
                                    i = "<C-b>",
                                },
                            },
                        },
                    },
                    ["help"] = {
                        opts = {
                            max_lines = 1000,
                        },
                    },
                },
            },
            inline = { adapter = "copilot" },
        },
        display = {
            action_palette = {
                provider = "default",
            },
            diff = {
                provider = "mini_diff",
            },
        },
        opts = {
            log_level = "DEBUG",
        },
    },
    keys = {
        { "<C-a>",      "<cmd>CodeCompanionActions<cr>" },
        { "<Leader>ci", "<cmd>CodeCompanion<cr>" },
        { "<Leader>cc", "<cmd>CodeCompanionChat toggle<cr>" },
        { "<Leader>ce", "<cmd>CodeCompanion /explain<cr>",  mode = "v" },
    },
    init = function()
        vim.cmd([[cab cc CodeCompanion]])
    end
}
