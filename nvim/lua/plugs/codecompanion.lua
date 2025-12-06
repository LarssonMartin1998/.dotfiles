return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "echasnovski/mini.diff",
    },
    opts = {
        ignore_warnings = true,
        adapters = {
            http = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "claude-sonnet-4",
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
                                    return "o3-2025-04-16"
                                end,
                            },
                        },
                    })
                end,
            },
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
                keymaps = {
                    previous_chat = {
                        modes = {
                            n = "<Leader>[",
                        },
                    },

                    next_chat = {
                        modes = {
                            n = "<Leader>]",
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
        { "<Leader>x", "<cmd>CodeCompanionActions<cr>" },
        { "<Leader>c", "<cmd>CodeCompanionChat toggle<cr>" },
    },
}
