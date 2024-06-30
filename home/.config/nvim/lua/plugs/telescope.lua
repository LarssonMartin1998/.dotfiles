return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
        local dropdown = require("telescope.themes").get_dropdown({
            borderchars = {
                prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
            prompt_title = "",
            winblend = 20
        })

        require("telescope").setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = false,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        require("telescope").load_extension("fzf")
        local builtin = require("telescope.builtin")
        require("utils").add_keymaps({
            n = {
                ["<leader>to"] = {
                    cmd = function()
                        builtin.find_files(vim.tbl_extend("force", dropdown, {
                            prompt_prefix = "Files> ",
                            previewer = false,
                        }))
                    end
                },
                ["<leader>tf"] = {
                    cmd = function()
                        builtin.current_buffer_fuzzy_find(vim.tbl_extend("force", dropdown, {
                            prompt_prefix = "Find> "
                        }))
                    end
                },
                ["<leader>ta"] = {
                    cmd = function()
                        builtin.live_grep(vim.tbl_extend("force", dropdown, {
                            prompt_prefix = "Grep> "
                        }))
                    end
                },
                ["<leader>tb"] = {
                    cmd = function()
                        builtin.marks(vim.tbl_extend("force", dropdown, {
                            prompt_prefix = "Marks> "
                        }))
                    end
                }
            }
        })
    end,
}
