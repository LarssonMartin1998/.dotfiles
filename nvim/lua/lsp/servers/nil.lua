return {
    cmd = { "nil" },
    filetypes = { "nix" },
    root_markers = {
        "flake.nix",
        ".git"
    },
    settings = {
        ["nil"] = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
    on_attach = function(_, bufnr)
        vim.notify("TJENA BBY")
        vim.bo[bufnr].tabstop = 2
        vim.bo[bufnr].shiftwidth = 2
        vim.bo[bufnr].softtabstop = 2
    end
}
