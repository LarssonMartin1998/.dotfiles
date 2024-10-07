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
                "css",
                "regex",
                "dap_repl",
                "muttrc",
            },
            sync_install = false,
            -- This can be updated to a list of languages instead of defaulting to true
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-cr>",
                    node_incremental = "<C-cr>",
                    scope_incremental = false,
                    node_decremental = "<C-bs>",
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
                    },
                },
            },
        })
    end
}
