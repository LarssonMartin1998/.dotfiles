return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
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
                "rust",
                "cmake",
                "make",
                "yaml",
                "ninja",
                "gitignore",
            },
            sync_install = false,
            -- This can be updated to a list of languages instead of defaulting to true
            highlight = { enable = true },
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
    end,
}
