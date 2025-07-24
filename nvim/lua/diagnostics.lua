local utils = require("utils")

local function setup_colors()
    -- These are not apart of the Ayu color theme, however, I needed these
    -- colors while still fitting in with the rest
    local ayu_turquoise = "#5CCFE6"
    local ayu_dark_blue = "#3A7BD5"

    local colors = {
        info = ayu_dark_blue,
        hint = ayu_turquoise,
        warning = utils.ayu_colors.warning,
        error = utils.ayu_colors.error,
    }

    for _, highlight in ipairs({
        { "DiagnosticUnderlineInfo",  { undercurl = true, sp = colors.info } },
        { "DiagnosticUnderlineHint",  { undercurl = true, sp = colors.hint } },
        { "DiagnosticUnderlineWarn",  { undercurl = true, sp = colors.warning } },
        { "DiagnosticUnderlineError", { undercurl = true, sp = colors.error } },
        { "DiagnosticInfo",           { fg = colors.info } },
        { "DiagnosticHint",           { fg = colors.hint } },
        { "DiagnosticWarn",           { fg = colors.warning } },
        { "DiagnosticError",          { fg = colors.error } },
    }) do
        vim.api.nvim_set_hl(0, highlight[1], highlight[2])
    end
end

utils.create_user_event_cb("ColorsyncThemeChanged", setup_colors, "ColorsyncEvents")
setup_colors()

local sev = vim.diagnostic.severity
vim.diagnostic.config({
    underline = true,
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
