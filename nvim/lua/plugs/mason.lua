return {
    "williamboman/mason.nvim",
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    config = function()
        require("mason").setup({})
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- LLVM debugger
                "codelldb",

                -- C and C++
                "clangd",
                "clang-format",

                -- Rust
                "rust-analyzer",

                -- Go
                "gopls",
                "golangci-lint",
                "delve",

                -- Lua
                "lua-language-server",

                -- CMake
                "cmake-language-server",
                "cmakelang",

                -- Python
                "debugpy",
                "pyright",
            },
        })
    end
}
