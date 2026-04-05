local sev = vim.diagnostic.severity
vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    signs = {
        text = {
            [sev.ERROR] = "",
            [sev.WARN] = "",
            [sev.INFO] = "",
            [sev.HINT] = "",
        },
        numhl = {
            [sev.WARN] = "WarningMsg",
            [sev.ERROR] = "ErrorMsg",
            [sev.INFO] = "DiagnosticInfo",
            [sev.HINT] = "DiagnosticHint",
        },
    },
})
