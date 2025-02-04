return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufRead",
    config = function()
        local ibl = require("ibl")
        ibl.setup({
            debounce = 100,
            indent = {
                char = "▏",
            },
            scope = {
                enabled = true,
                char = "▏",
                show_start = false,
                show_end = false,
                highlight = { "IblScope" },
            },
        })

        local colors = require("ayu.colors")
        colors.generate(true)
        local highlights = {
            { "IblScope",          { fg = colors.keyword } },
            { "@ibl.scope.char.1", { fg = colors.keyword } },
        }

        for _, hl in ipairs(highlights) do
            vim.api.nvim_set_hl(0, hl[1], hl[2])
        end
    end
}
