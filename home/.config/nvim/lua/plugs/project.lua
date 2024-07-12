return {
    "LennyPhoenix/project.nvim",
    branch = "fix-get_clients",
    -- This plugin does not have a lua module and we have to use config
    config = function()
        require("project_nvim").setup({
            patterns = {
                ".git",
                ".hg",
                ".svn",
                "Makefile",
                "package.json",
                "Cargo.toml",
                "go.mod",
                ".clang-tidy",
                ".clang-format"
            },
        })
    end,
}
