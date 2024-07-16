local M = {}

local function is_single_keymap_table(map_table)
    assert(map_table)
    return map_table.n or map_table.t or map_table.i or map_table.v or map_table.x or map_table.o
end

function M.create_user_event_cb(event_name, function_callback, augroup)
    assert(event_name and event_name ~= "", "Event name must be provided")
    assert(function_callback and type(function_callback) == "function", "Callback must be a valid function")

    local cmd = {
        callback = function_callback,
        pattern = event_name,
    }

    if augroup then
        cmd.group = augroup
    end

    vim.api.nvim_create_autocmd("User", cmd)
end

function M.broadcast_event(event_name)
    vim.api.nvim_command("doautocmd <nomodeline> User " .. event_name)
end

function M.add_keymaps(maps)
    assert(maps)

    local function set_keymaps(map_table)
        for mode, entries in pairs(map_table) do
            for code, info in pairs(entries) do
                vim.keymap.set(mode, code, info.cmd, info.opts)
            end
        end
    end

    if is_single_keymap_table(maps) then
        set_keymaps(maps)
    else
        for _, map_table in pairs(maps) do
            set_keymaps(map_table)
        end
    end
end

function M.remove_keymaps(maps)
    assert(maps)

    local function del_keymaps(map_table)
        for mode, entries in pairs(map_table) do
            for code, _ in pairs(entries) do
                vim.keymap.del(mode, code)
            end
        end
    end

    if is_single_keymap_table(maps) then
        del_keymaps(maps)
    else
        for _, map_table in pairs(maps) do
            del_keymaps(map_table)
        end
    end
end

function M.is_buf_filetype(bufnr, filetype)
    return vim.api.nvim_buf_get_option(bufnr, "filetype") == filetype
end

function M.is_buf_buftype(bufnr, filetype)
    return vim.api.nvim_buf_get_option(bufnr, "buftype") == filetype
end

function M.lock_buf_to_window(win_id, bufnr, filetype)
    local augroup_id = vim.api.nvim_create_augroup("LockWindow" .. win_id, { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup_id,
        callback = function()
            local current_win = vim.api.nvim_get_current_win()
            if current_win ~= win_id then
                return
            end

            local current_buf = vim.api.nvim_win_get_buf(win_id)
            if current_buf == bufnr then
                return
            end

            if M.is_buf_filetype(current_buf, filetype) then
                bufnr = current_buf
                return
            end

            vim.api.nvim_win_set_buf(win_id, bufnr)
        end,
    })
end

function M.calculate_split_size(term_size, percentage, min_size, max_size)
    local calculated_size = math.floor(term_size * percentage)
    return math.min(math.max(calculated_size, min_size), max_size)
end

return M
