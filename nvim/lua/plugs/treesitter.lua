return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                max_lines = 2,           -- How many lines the window should span. Values <= 0 mean no limit.
                multiline_threshold = 3, -- Maximum number of lines to show for a single context
                trim_scope = "inner",    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            }
        },
        "nvim-treesitter/nvim-treesitter-textobjects",
        "OXY2DEV/markview.nvim",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vim",
                "vimdoc",
                "bash",
                "lua",
                "c",
                "cpp",
                "c_sharp",
                "rust",
                "cmake",
                "make",
                "yaml",
                "ninja",
                "gitignore",
                "markdown",
                "markdown_inline",
                "hyprlang",
                "json",
                "html",
                "hlsl",
                "glsl",
                "gdshader",
                "gdscript",
                "dockerfile",
                "dart",
                "go",
                "zig",
                "css",
                "regex",
                "dap_repl",
                "muttrc",
                "python",
                "latex",
                "typst",
                "ruby",
                "svelte",
                "typescript",
                "just",
                "tsx",
                "javascript",
                "jsonc",
            },
            sync_install = false,
            -- This can be updated to a list of languages instead of defaulting to true
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = false,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["ic"] = { query = "@class.inner" },
                        ["ac"] = { query = "@class.outer" },
                        ["ii"] = { query = "@conditional.inner" },
                        ["ai"] = { query = "@conditional.outer" },
                        ["if"] = { query = "@function.inner" },
                        ["af"] = { query = "@function.outer" },
                        ["il"] = { query = "@loop.inner" },
                        ["al"] = { query = "@loop.outer" },
                        ["ia"] = { query = "@attribute.inner" },
                        ["aa"] = { query = "@attribute.outer" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[i"] = "@conditional.outer",
                        ["[c"] = "@class.outer",
                        ["[l"] = "@loop.outer",
                    },
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]i"] = "@conditional.outer",
                        ["]c"] = "@class.outer",
                        ["]l"] = "@loop.outer",
                    },
                },
            },
        })
    end
}
