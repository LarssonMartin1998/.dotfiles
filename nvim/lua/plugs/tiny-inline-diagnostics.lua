return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup()

        vim.diagnostic.config({
            virtual_text = false,
        })

        vim.cmd [[
        highlight DiagnosticUnderlineError gui=undercurl guisp=#ff0000   " Red for error
        highlight DiagnosticUnderlineWarn gui=undercurl guisp=#ffaa00    " Yellow/Orange for warning
        highlight DiagnosticUnderlineHint gui=undercurl guisp=#00ffff    " Cyan for hint
        highlight DiagnosticUnderlineInfo gui=undercurl guisp=#0000ff    " Blue for info
    ]]
    end
}
