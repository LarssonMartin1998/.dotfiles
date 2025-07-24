local M = {}

M.colorsync_theme = nil
M.ayu_colors = nil

function M.set_keymap_list(keymap_list, mode)
    mode = mode or "n"
    M.foreach(keymap_list, function(mapping)
        vim.keymap.set(mode, mapping[1], mapping[2], mapping[3] or {})
    end)
end

function M.del_keymap_list(keymap_list, mode)
    mode = mode or "n"
    M.foreach(keymap_list, function(mapping)
        vim.keymap.del(mode, mapping[1])
    end)
end

function M.get_file_names_in_dir(dir, expr, strip_extension)
    local path = vim.fn.stdpath("config") .. "/lua/" .. dir
    local files_str = vim.fn.globpath(path, expr, true)
    local has_line_breaks = vim.fn.match(files_str, [[\n]]) > -1
    local files = has_line_breaks and vim.fn.split(files_str, "\n") or { files_str }

    local should_strip_extension = strip_extension or false
    if should_strip_extension then
        return vim.tbl_map(function(file)
            return vim.fn.fnamemodify(file, ":t:r")
        end, files)
    else
        return files
    end
end

function M.validate_bufnr(bufnr)
    vim.validate('bufnr', bufnr, 'number')
    return bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
end

function M.xpcallmsg(fn, err_msg, err_container)
    return xpcall(fn, function(err)
        if err_container then
            table.insert(err_container, err_msg .. ": " .. err)
        else
            error(err_msg .. ": " .. err)
        end
    end)
end

function M.foreach(t, f)
    for _, v in pairs(t) do
        f(v)
    end
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

function M.add_opts_to_all_mappings(mappings, opts)
    assert(opts and mappings)

    for _, modes in pairs(mappings) do
        for _, mapping in pairs(modes) do
            local existing_opts = mapping.opts or {}
            mapping.opts = vim.tbl_extend("force", existing_opts, opts)
        end
    end
end

function M.is_buf_filetype(bufnr, filetype)
    return vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == filetype
end

function M.is_buf_buftype(bufnr, buftype)
    return vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == buftype
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
