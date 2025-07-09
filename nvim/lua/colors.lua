local has_generated = false
local colors = require("ayu.colors")
colors.generate(true)

local M = {}

function M.get()
    if not has_generated then
        colors.generate(true)
        has_generated = true
    end

    return colors
end

return M
