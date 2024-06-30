return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
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

        local dropdown = require("telescope.themes").get_dropdown({
            borderchars = {
                prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
            prompt_title = "",
            winblend = 20
        })

        local pickers = {
            {
                fn = builtin.find_files,
                key = "o",
                picker_opts = {
                    prompt_prefix = "Files> ",
                    previewer = false,
                },
            },
            {
                fn = builtin.current_buffer_fuzzy_find,
                key = "f",
                picker_opts = {
                    prompt_prefix = "Find> "
                },
            },
            {
                fn = builtin.live_grep,
                key = "a",
                picker_opts = {
                    prompt_prefix = "Grep> "
                },
            },
            {
                fn = builtin.marks,
                key = "b",
                picker_opts = {
                    prompt_prefix = "Marks> "
                },
            },
        }
        -- Cache the options with the dropdown theme for each picker so we don't
        -- recalculate it every time we open a picker
        for _, v in ipairs(pickers) do
            v.picker_opts = vim.tbl_extend("force", dropdown, v.picker_opts)
        end

        local keymaps = { n = {} }
        for _, v in ipairs(pickers) do
            keymaps.n["<leader>t" .. v.key] = {
                cmd = function()
                    v.fn(v.picker_opts)
                end
            }
        end
        require("utils").add_keymaps(keymaps)
    end,
}
