local M = {}

function M.get_breadcrumbs()
    local breadcrumbs = require("lspsaga.symbol.winbar").get_bar()
    -- Return breadcrumbs if the string exists and is not empty, otherwise, get the filename and return it
    return breadcrumbs and breadcrumbs ~= "" and breadcrumbs or vim.fn.expand("%:t")
end

return M
