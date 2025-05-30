local terminal_window = nil
local terminal_bufnr = nil

local function open_terminal_window()
    local utils = require("utils")
    if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) and utils.is_buf_buftype(terminal_bufnr, "terminal") then
        vim.cmd("botright split")
        terminal_window = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(terminal_window, terminal_bufnr)
    else
        vim.cmd("botright split term://zsh")
        terminal_window = vim.api.nvim_get_current_win()
        terminal_bufnr = vim.api.nvim_get_current_buf()
    end
end

local function toggle_terminal()
    if terminal_window and vim.api.nvim_win_is_valid(terminal_window) then
        vim.api.nvim_win_close(terminal_window, true)
        terminal_window = nil
        return
    end

    local utils = require("utils")
    open_terminal_window()

    local term_height = vim.api.nvim_get_option_value("lines", {})
    local height_percentage = 0.225
    local min_height = 15
    local max_height = 25
    local height = utils.calculate_split_size(term_height, height_percentage, min_height, max_height)

    vim.api.nvim_win_set_height(terminal_window, height)
    vim.api.nvim_set_option_value("winfixheight", true, { win = terminal_window })
    utils.lock_buf_to_window(terminal_window, terminal_bufnr, "terminal")
    vim.api.nvim_command("startinsert")
end

vim.keymap.set("n", "<leader>t", function()
    toggle_terminal()
    require("window_management").autosize_windows()
end)
