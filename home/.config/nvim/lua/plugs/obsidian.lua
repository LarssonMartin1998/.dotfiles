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

        local is_vault_accessible = scndbrn_path == nil or vim.fn.isdirectory(scndbrn_path) == 0
        if is_vault_accessible then
            return
        end

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
