local utils = require("utils")

local oil = nil
local oil_window = nil

local function toggle_oil_window()
    if oil_window and vim.api.nvim_win_is_valid(oil_window) then
        vim.api.nvim_win_close(oil_window, true)
        oil_window = nil
        return
    end

    local term_width = vim.api.nvim_get_option("columns")
    local width_percentage = 0.1575
    local min_width = 30
    local max_width = 50
    local width = utils.calculate_split_size(term_width, width_percentage, min_width, max_width)

    vim.cmd("topleft vertical " .. width .. "vnew")
    oil_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_option(oil_window, "winfixwidth", true)
    vim.api.nvim_win_set_option(oil_window, "winhighlight", "Normal:Utility,FloatBorder:Utility")

    oil.open()
    local oil_buf_id = vim.api.nvim_get_current_buf()
    utils.lock_buf_to_window(oil_window, oil_buf_id, "oil")
end

return {
    "stevearc/oil.nvim",
    config = function()
        oil = require("oil")
        oil.setup({
            view_options = {
                show_hidden = true,
            },
            win_options = {
                wrap = true,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
        })

        require("utils").add_keymaps({
            n = {
                ["<leader>o"] = {
                    cmd = toggle_oil_window,
                }
            }
        })
    end,
}
