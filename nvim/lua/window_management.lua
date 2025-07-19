local utils = require("utils")

local M = {}

local is_in_resizing_mode = false
local on_resize_mode_enter_event = "ResizeModeEnter"
local on_resize_mode_exit_event = "ResizeModeExit"

local function is_floating_window(window)
    assert(window, "Invalid window")

    return vim.api.nvim_win_get_config(window).relative ~= ""
end

local function window_has_valid_buffer(window)
    assert(window, "Invalid window")

    local buf = vim.api.nvim_win_get_buf(window)
    if not buf then
        return false
    end

    -- An empty bufname is alright, for instance if we have a new empty buffer
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if not buf_name then
        return false
    end

    local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
    if buf_type ~= "" then
        return false
    end

    return true
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

    local function can_swap_window(window)
        if not window then
            return true
        end

        if is_floating_window(window) then
            return true
        end

        if not window_has_valid_buffer(window) then
            return true
        end

        return false
    end

    local required_num_windows = 2
    if get_total_num_windows_open() < required_num_windows then
        return
    end

    local current_window = vim.api.nvim_get_current_win()
    if can_swap_window(current_window) then
        return
    end

    if is_current_window_at_edge(dir_char) then
        return
    end

    local adjacent_window = get_adjacent_window(dir_char)
    assert(adjacent_window ~= nil, "Invalid adjacent window from get_adjacent_window")

    if can_swap_window(adjacent_window) then
        return
    end

    swap_buffer_between_windows(current_window, adjacent_window)
    vim.api.nvim_set_current_win(adjacent_window)

    assert(vim.api.nvim_get_current_win() == adjacent_window, "Failed to swap windows")
end

-- Vims rebinding naming is confusing, using these helper functions for consistency
local function shrink_horizontally(units)
    vim.cmd("vertical resize -" .. units)
end

local function grow_horizontally(units)
    vim.cmd("vertical resize +" .. units)
end

local function shrink_vertically(units)
    vim.cmd("resize -" .. units)
end

local function grow_vertically(units)
    vim.cmd("resize +" .. units)
end

local function resize_window(window, dir_char)
    assert(is_in_resizing_mode, "Not in resizing mode")
    assert(window, "Invalid window")
    assert(dir_char == "h" or dir_char == "j" or dir_char == "k" or dir_char == "l", "Invalid direction character")

    local function can_resize_window(win)
        if not win then
            return false
        end

        if get_total_num_windows_open() <= 1 then
            return false
        end

        if is_floating_window(win) then
            return false
        end

        return true
    end

    if not can_resize_window(window) then
        return
    end

    local function handle_resize_in_direction(resize_input, resize_opt)
        local is_at_lower_edge = is_current_window_at_edge(resize_opt.shrink_dir)
        local is_at_upper_edge = is_current_window_at_edge(resize_opt.grow_dir)
        if is_at_lower_edge and is_at_upper_edge then
            -- Can't resize if there is no windows in the given direction.
            return
        end

        local is_resize_input_lower = resize_input == resize_opt.shrink_dir
        local is_resize_input_upper = resize_input == resize_opt.grow_dir

        local is_window_in_middle = not is_at_lower_edge and not is_at_upper_edge
        if is_window_in_middle then
            if is_resize_input_lower then
                local current_window = vim.api.nvim_get_current_win()
                local lower_adjacent_window = get_adjacent_window(resize_opt.shrink_dir)
                assert(lower_adjacent_window ~= nil, "Invalid lower_adjacent_window from get_adjacent_window")

                -- Neovim doesn't allow for specifying the direction of resizing
                -- We work around this by changing window and resizing neighbours.
                vim.api.nvim_set_current_win(lower_adjacent_window)
                resize_opt.shrink_func(resize_opt.resize_units)
                vim.api.nvim_set_current_win(current_window)
            else
                resize_opt.grow_func(resize_opt.resize_units)
            end
        else
            if (is_at_lower_edge and is_resize_input_lower) or (is_at_upper_edge and is_resize_input_upper) then
                resize_opt.shrink_func(resize_opt.resize_units)
            else
                resize_opt.grow_func(resize_opt.resize_units)
            end
        end
    end

    local horizontal_resize_units = 5
    local vertical_resize_units = 3
    if dir_char == "h" or dir_char == "l" then
        handle_resize_in_direction(dir_char, {
            shrink_dir = "h",
            grow_dir = "l",
            resize_units = horizontal_resize_units,
            shrink_func = shrink_horizontally,
            grow_func = grow_horizontally
        })
    else
        handle_resize_in_direction(dir_char, {
            shrink_dir = "k",
            grow_dir = "j",
            resize_units = vertical_resize_units,
            shrink_func = shrink_vertically,
            grow_func = grow_vertically
        })
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

    if not window_has_valid_buffer(current_window) then
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
        { "h",       function() resize_window(vim.api.nvim_get_current_win(), "h") end },
        { "j",       function() resize_window(vim.api.nvim_get_current_win(), "j") end },
        { "k",       function() resize_window(vim.api.nvim_get_current_win(), "k") end },
        { "l",       function() resize_window(vim.api.nvim_get_current_win(), "l") end },
        { "<Left>",  function() resize_window(vim.api.nvim_get_current_win(), "h") end },
        { "<Down>",  function() resize_window(vim.api.nvim_get_current_win(), "j") end },
        { "<Up>",    function() resize_window(vim.api.nvim_get_current_win(), "k") end },
        { "<Right>", function() resize_window(vim.api.nvim_get_current_win(), "l") end },
        { "<Esc>",   function() exit_resizing_mode() end },
        { "<Enter>", function() exit_resizing_mode() end },
        { "=",       function() M.autosize_windows() end },
    }
    local enter_resizing_mode_keymaps = {
        { "<C-Space>", function() enter_resizing_mode() end }
    }
    local window_shifting_keymaps = {
        { "<C-S-Left>",  function() swap_window("h") end },
        { "<C-S-Down>",  function() swap_window("j") end },
        { "<C-S-Up>",    function() swap_window("k") end },
        { "<C-S-Right>", function() swap_window("l") end },
    }

    utils.set_keymap_list(window_shifting_keymaps)
    utils.set_keymap_list(enter_resizing_mode_keymaps)

    local function on_resize_mode_enter()
        utils.del_keymap_list(enter_resizing_mode_keymaps)
        utils.set_keymap_list(resizing_mode_keymaps)
    end

    local function on_resize_mode_exit()
        utils.del_keymap_list(resizing_mode_keymaps)
        utils.set_keymap_list(enter_resizing_mode_keymaps)
    end

    local window_management_augroup = "WindowManagementEvents"
    vim.api.nvim_create_augroup(window_management_augroup, { clear = true })
    utils.create_user_event_cb(on_resize_mode_enter_event, on_resize_mode_enter, window_management_augroup)
    utils.create_user_event_cb(on_resize_mode_exit_event, on_resize_mode_exit, window_management_augroup)
end

return M
