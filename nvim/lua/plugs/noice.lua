return {
    "folke/noice.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = {
        { "MunifTanjim/nui.nvim", lazy = true },
    },
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = false,      -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = true,            -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
        notify = {
            level = "warn",
        },
        views = {
            cmdline_popup = {
                border = {
                    style = "single",
                    padding = { 0, 0 },
                },
            },
            cmdline_popupmenu = {
                border = {
                    style = "single",
                    padding = { 0, 0 },
                },
            },
            hover = {
                border = {
                    style = "single",
                },
            },
            confirm = {
                border = {
                    style = "single",
                },
            },
            popup = {
                border = {
                    style = "single",
                },
            },
        },
    },
}
