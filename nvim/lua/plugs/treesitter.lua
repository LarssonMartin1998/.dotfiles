return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "vim",
            "vimdoc",
            "lua"
        },
        sync_install = false,
        -- This can be updated to a list of languages instead of defaulting to true
        highlight = { enable = true },
        indent = {enable = true },
    },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context"
    }
}
