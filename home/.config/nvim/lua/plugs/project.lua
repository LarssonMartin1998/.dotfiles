return {
    "ahmedkhalf/project.nvim",
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
