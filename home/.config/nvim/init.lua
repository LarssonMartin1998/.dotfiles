local function setup_yank_highlight()
    -- Create a new highlight group which will be used for yank highlighting with the name "YankHighlight"
    vim.cmd("highlight YankHighlight guibg=#e0af68")

    -- Create an autocommand group called "YankHighlight" and clear it
    local yank_autocommand = vim.api.nvim_create_augroup("YankHighlightAutocommand", { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                timeout = 250,
                higroup = "YankHighlight",
            })
        end,
        group = yank_autocommand,
        pattern = "*",
    })
end

-- Load keymaps before loading any plugins
require("keymaps")

-- change and personalize native vim settings
vim.opt = require("vim_opt")

-- Initialize Lazy package manager
require("lazy_init")

-- Initialize plugins, add a plugin by creating a new file in the plugins dir
require("lazy").setup("plugs")

-- Initialize the sticky terminal window at the bottom
require("terminal").setup()

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()

-- Extract to plugin later
local function is_floating_window(window)
    return vim.api.nvim_win_get_config(window).relative ~= ""
end

local function is_window_resizable(window)
    local config = vim.api.nvim_win_get_config(window)
    return not config.winfixwidth and not config.winfixheight
end

local function get_total_num_windows_open()
    return #vim.api.nvim_tabpage_list_wins(0)
end

local function get_adjacent_window(dir_char)
    assert(dir_char == "h" or dir_char == "j" or dir_char == "k" or dir_char == "l", "Invalid direction character")
    local current_window = vim.api.nvim_get_current_win()
    assert(current_window, "Current window is nil")

    vim.cmd("wincmd " .. dir_char)
    local new_window = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(current_window)

    assert(vim.api.nvim_get_current_win() == current_window, "Cursor moved to a different window")
    return new_window
end

local function is_current_window_at_edge(dir_char)
    return vim.api.nvim_get_current_win() == get_adjacent_window(dir_char)
end

local function swap_buffer_between_windows(window_a, window_b)
    assert(window_a and window_b, "Invalid window")

    local buffer_a = vim.api.nvim_win_get_buf(window_a)
    local buffer_b = vim.api.nvim_win_get_buf(window_b)
    vim.api.nvim_win_set_buf(window_a, buffer_b)
    vim.api.nvim_win_set_buf(window_b, buffer_a)

    assert(vim.api.nvim_win_get_buf(window_a) == buffer_b and vim.api.nvim_win_get_buf(window_b) == buffer_a,
        "Failed to swap buffers")
end

local function swap_window(dir_char)
    assert(dir_char == "h" or dir_char == "j" or dir_char == "k" or dir_char == "l", "Invalid direction character")
    local current_window = vim.api.nvim_get_current_win()
    assert(current_window, "Current window is nil")

    local required_num_windows = 2
    if get_total_num_windows_open() < required_num_windows then
        return
    end

    if is_floating_window(current_window) then
        return
    end

    if is_current_window_at_edge(dir_char) then
        return
    end

    if not is_window_resizable(current_window) then
        return
    end

    local adjacent_window = get_adjacent_window(dir_char)
    if not is_window_resizable(adjacent_window) then
        return
    end

    swap_buffer_between_windows(current_window, adjacent_window)
end

require("utils").add_keymaps({
    n = {
        -- ["<C-S>Left"] = {
        ["h"] = {
            cmd = function()
                swap_window("h")
            end
        },
        -- ["<C-S>Down"] = {
        ["j"] = {
            cmd = function()
                swap_window("j")
            end
        },
        -- ["<C-S>Up"] = {
        ["k"] = {
            cmd = function()
                swap_window("k")
            end
        },
        -- ["<C-S>Right"] = {
        ["l"] = {
            cmd = function()
                swap_window("l")
            end
        },
    },
})
