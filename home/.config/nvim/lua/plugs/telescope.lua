return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_drop,
                        },
                        n = {
                            ["<CR>"] = actions.select_drop,
                        }
                    }
                },
                find_files = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_drop,
                        },
                        n = {
                            ["<CR>"] = actions.select_drop,
                        }
                    }
                },
                git_files = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_drop,
                        },
                        n = {
                            ["<CR>"] = actions.select_drop,
                        }
                    }
                },
                old_files = {
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_drop,
                        },
                        n = {
                            ["<CR>"] = actions.select_drop,
                        }
                    }
                },
            }
        })
        require("telescope").load_extension("fzf")

        local dropdown_theme = require('telescope.themes').get_dropdown({
            -- results_height = 50,
            width = 0.2,
            winblend = 20,
            prompt_title = "",
            borderchars = {
                { "", "", "", "", "", "", "", "" },
                prompt = { "", "", "", "", "", "", "", "" },
                results = { "", "", "", "", "", "", "", "" },
                preview = { "", "", "", "", "", "", "", "" },
            }
        })

        local builtin = require("telescope.builtin")
        require("utils").add_keymaps({
            n = {
                -- File search
                ["<leader>to"] = {
                    cmd = function()
                        dropdown_theme.prompt_prefix = "Files>"
                        dropdown_theme.previewer = false
                        dropdown_theme.find_command = nil
                        builtin.find_files(dropdown_theme)
                    end,
                },
                ["<leader>tf"] = {
                    cmd = function()
                        dropdown_theme.prompt_prefix = "Find>"
                        dropdown_theme.previewer = true
                        dropdown_theme.find_command = nil
                        builtin.current_buffer_fuzzy_find(dropdown_theme)
                    end,
                },
                ["<leader>ta"] = {
                    -- cmd = ":lua require('telescope.builtin').live_grep({find_command=rg,--ignore-file,.gitignore,--exclude,*.git,--exclude,*.svn,--exclude,*.vs,--exclude,*.idea}) <CR>",
                    cmd = function()
                        dropdown_theme.prompt_prefix = "Grep>"
                        dropdown_theme.previewer = true
                        dropdown_theme.find_command = {
                            find_command = "rg",
                            "--ignore-file",
                            ".gitignore",
                            "--exclude",
                            "*.git",
                            "--exclude",
                            "*.svn",
                            "--exclude",
                            "*.vs",
                            "--exclude",
                            "*.idea",
                        }

                        builtin.live_grep(dropdown_theme)
                    end,
                },
                -- Misc
                ["<leader>tb"] = {
                    cmd = function()
                        dropdown_theme.prompt_prefix = "Marks>"
                        dropdown_theme.previewer = true
                        dropdown_theme.find_command = nil
                        builtin.marks(dropdown_theme)
                    end,
                }
            }
        })
    end,
}
