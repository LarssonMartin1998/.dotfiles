local utils = require("utils")

local M = {}

local is_in_resizing_mode = false
local on_resize_mode_enter_event = "ResizeModeEnter"
local on_resize_mode_exit_event = "ResizeModeExit"

local function is_floating_window(window)
    assert(window, "Invalid window")

    return vim.api.nvim_win_get_config(window).relative ~= ""
end

local function is_window_resizable(window)
    assert(window, "Invalid window")

    local config = vim.api.nvim_win_get_config(window)
    return not config.winfixwidth and not config.winfixheight
end

local function get_total_num_windows_open()
    return #vim.api.nvim_tabpage_list_wins(0)
end

local function get_adjacent_window(dir_char)
    assert(dir_char == "h" or dir_char == "j" or dir_char == "k" or dir_char == "l", "Invalid direction character")

    local current_window = vim.api.nvim_get_current_win()
    if not current_window then
        return
    end

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

    local required_num_windows = 2
    if get_total_num_windows_open() < required_num_windows then
        return
    end

    local current_window = vim.api.nvim_get_current_win()
    if not current_window then
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
    vim.api.nvim_set_current_win(adjacent_window)

    assert(vim.api.nvim_get_current_win() == adjacent_window, "Failed to swap windows")
end

local function resize_window(window, dir_char)
    assert(is_in_resizing_mode, "Not in resizing mode")
    assert(window, "Invalid window")
    assert(dir_char == "h" or dir_char == "j" or dir_char == "k" or dir_char == "l", "Invalid direction character")

    local default_resize_units = 5
    local tot_resize_units = default_resize_units * vim.v.count1
    if dir_char == "h" then
        vim.cmd("vertical resize -" .. tot_resize_units)
    elseif dir_char == "j" then
        vim.cmd("resize " .. tot_resize_units)
    elseif dir_char == "k" then
        vim.cmd("resize -" .. tot_resize_units)
    elseif dir_char == "l" then
        vim.cmd("vertical resize " .. tot_resize_units)
    end
end

local function exit_resizing_mode()
    assert(is_in_resizing_mode, "Not in resizing mode")

    is_in_resizing_mode = false
    utils.broadcast_event(on_resize_mode_exit_event)

    assert(not is_in_resizing_mode, "Failed to exit resizing mode")
end

local function enter_resizing_mode()
    assert(not is_in_resizing_mode, "Already in resizing mode")

    local current_window = vim.api.nvim_get_current_win()
    if not current_window then
        return
    end

    if is_floating_window(current_window) then
        return
    end

    if not is_window_resizable(current_window) then
        return
    end

    is_in_resizing_mode = true
    utils.broadcast_event(on_resize_mode_enter_event)

    assert(is_in_resizing_mode, "Failed to enter resizing mode")
end

function M.autosize_windows()
    vim.api.nvim_command("wincmd =")
end

function M.is_in_resizing_mode()
    return is_in_resizing_mode
end

function M.setup()
    local resizing_mode_keymaps = {
        n = {
            ["<Left>"] = {
                cmd = function() resize_window(vim.api.nvim_get_current_win(), "h") end
            },
            ["<Down>"] = {
                cmd = function() resize_window(vim.api.nvim_get_current_win(), "j") end
            },
            ["<Up>"] = {
                cmd = function() resize_window(vim.api.nvim_get_current_win(), "k") end
            },
            ["<Right>"] = {
                cmd = function() resize_window(vim.api.nvim_get_current_win(), "l") end
            },
            ["<Esc>"] = {
                cmd = function() exit_resizing_mode() end
            },
            ["<Enter>"] = {
                cmd = function() exit_resizing_mode() end
            },
        }
    }
    local enter_resizing_mode_keymaps = {
        n = {
            ["<C- >"] = {
                cmd = function() enter_resizing_mode() end
            }
        },
    }
    local window_shifting_keymaps = {
        n = {
            ["<C-S-Left>"] = {
                cmd = function()
                    swap_window("h")
                end
            },
            ["<C-S-Down>"] = {
                cmd = function()
                    swap_window("j")
                end
            },
            ["<C-S-Up>"] = {
                cmd = function()
                    swap_window("k")
                end
            },
            ["<C-S-Right>"] = {
                cmd = function()
                    swap_window("l")
                end
            },
        },
    }

    utils.add_keymaps({
        window_shifting_keymaps,
        enter_resizing_mode_keymaps
    })

    local function on_resize_mode_enter()
        utils.remove_keymaps(enter_resizing_mode_keymaps)
        utils.add_keymaps(resizing_mode_keymaps)
    end

    local function on_resize_mode_exit()
        utils.remove_keymaps(resizing_mode_keymaps)
        utils.add_keymaps(enter_resizing_mode_keymaps)
    end

    local window_management_augroup = "WindowManagementEvents"
    vim.api.nvim_create_augroup(window_management_augroup, { clear = true })
    utils.create_user_event_cb(on_resize_mode_enter_event, on_resize_mode_enter, window_management_augroup)
    utils.create_user_event_cb(on_resize_mode_exit_event, on_resize_mode_exit, window_management_augroup)
end

return M
