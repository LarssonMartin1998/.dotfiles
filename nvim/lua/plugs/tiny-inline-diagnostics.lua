return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup()

        vim.diagnostic.config({
            virtual_text = false,
        })

        local colors = require("ayu.colors")
        colors.generate(true)
        -- These are not apart of the Ayu color theme, however, I needed these
        -- colors while still fitting in with the rest
        local ayu_turquoise = "#5CCFE6"
        local ayu_dark_blue = "#3A7BD5"
        for _, highlight in ipairs({
            { "DiagnosticUnderlineError", { undercurl = true, sp = colors.error } },
            { "DiagnosticUnderlineWarn",  { undercurl = true, sp = colors.warning } },
            { "DiagnosticUnderlineHint",  { undercurl = true, sp = ayu_turquoise } },
            { "DiagnosticUnderlineInfo",  { undercurl = true, sp = ayu_dark_blue } },
        }) do
            vim.api.nvim_set_hl(0, highlight[1], highlight[2])
        end
    end
}
