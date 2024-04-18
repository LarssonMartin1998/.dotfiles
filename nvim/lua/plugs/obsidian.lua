return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local scndbrn_path = vim.fn.has("unixmac") == 1 and
            "~/rp4-data/obsidian-vault/scndbrn" or
            "/mnt/rp4-data/obsidian-vault/scndbrn"
        require("obsidian").setup({
            workspaces = {
                {
                    name = "scndbrn",
                    path = scndbrn_path,
                },
            },
        })
    end,
}
