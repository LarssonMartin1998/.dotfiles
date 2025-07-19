return {
    cmd = {
        "tailwindcss-language-server",
        "--stdio"
    },
    filetypes = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact"
    },
    root_markers = {
        "tailwind.config.js",
        "tailwind.config.ts",
        "vite.config.ts",
        "package.json",
        ".eslintrc.js",
        ".gitignore",
        ".prettierrc",
        "tsconfig.json",
    },
    settings = {
        tailwindCSS = {
            validate = true,
            classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
            },
        },
    },
}
