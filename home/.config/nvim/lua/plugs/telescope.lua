return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build =
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        }
    },
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("telescope").setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        require("telescope").load_extension("fzf")
        local dropdown = require("telescope.themes").get_dropdown({
            borderchars = {
                prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
            prompt_title = "",
            winblend = 20,
            width = 0.75
        })

        local builtin = require("telescope.builtin")
        local pickers = {
            -- {
            --     fn = builtin.find_files,
            --     key = "o",
            --     picker_opts = {
            --         prompt_prefix = "Files> ",
            --         previewer = false,
            --     },
            -- },
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
                    prompt_prefix = "Grep> ",
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
        local fzf_sorter = require("telescope.sorters").get_fzy_sorter()
        for _, v in ipairs(pickers) do
            -- Make sure all custom pickers are set to use the fzf sorter
            v.picker_opts.sorter = fzf_sorter
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
