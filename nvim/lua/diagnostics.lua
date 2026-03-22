local sev = vim.diagnostic.severity
vim.diagnostic.config({
    -- underline = true,
    -- This enables the diagnostics at end of line
    -- virtual_text = {
    --     prefix = "●",
    -- },
    -- Disable this whilst using tiny inline diagnostics
    virtual_text = false,
    -- This enables the separate buffer diagnostics
    -- virtual_lines = true,
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
