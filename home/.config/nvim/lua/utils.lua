local M = {}

local overridden_default_keymaps = {}

local function is_single_keymap_table(map_table)
    assert(map_table)
    return map_table.n or map_table.t or map_table.i or map_table.v or map_table.x or map_table.o
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

local function pass_keymap_tbl_to_fn(maps, fn)
    if is_single_keymap_table(maps) then
        fn(maps)
    else
        for _, map_table in pairs(maps) do
            fn(map_table)
        end
    end
end

local function get_keymaps(mode, buffer)
    if buffer then
        return vim.api.nvim_buf_get_keymap(buffer, mode)
    end

    return vim.api.nvim_get_keymap(mode)
end

function M.add_temporary_keymaps(maps)
    assert(maps)

    pass_keymap_tbl_to_fn(maps, function(map_table)
        for mode, entries in pairs(map_table) do
            -- We make an assumptino here which is that all the entries are buffers, or not buffers.
            -- Meaning, we only check the first entry and trust that the rest are the same.
            local result = get_keymaps(mode, (function()
                for _, entry in pairs(entries) do
                    -- nil buffer is treated as a global keymap
                    return entry.buffer
                end
            end)())

            for code, _ in pairs(entries) do
                for _, map in ipairs(result) do
                    if map.lhs == code then
                        if not overridden_default_keymaps[mode] then
                            overridden_default_keymaps[mode] = {}
                        end

                        overridden_default_keymaps[mode][code] = {
                            cmd = map.callback or map.rhs,
                            opts = {
                                noremap = map.noremap == 1,
                                expr = map.expr == 1,
                                silent = map.silent == 1,
                                nowait = map.nowait == 1,
                                script = map.script == 1,
                                buffer = type(map.buffer) == "number" and map.buffer or nil,
                            },
                        }
                    end
                end
            end
        end
    end)

    M.add_keymaps(maps)
end

function M.add_keymaps(maps)
    assert(maps)

    pass_keymap_tbl_to_fn(maps, function(map_table)
        for mode, entries in pairs(map_table) do
            for code, info in pairs(entries) do
                vim.keymap.set(mode, code, info.cmd, info.opts)
            end
        end
    end)
end

function M.remove_keymaps(maps)
    assert(maps)

    pass_keymap_tbl_to_fn(maps, function(map_table)
        for mode, entries in pairs(map_table) do
            local overriden_mode = overridden_default_keymaps[mode]
            for code, _ in pairs(entries) do
                vim.keymap.del(mode, code)

                if overriden_mode and overriden_mode[code] then
                    vim.keymap.set(mode, code, overriden_mode[code].cmd, overriden_mode[code].opts)
                end
            end
        end
    end)
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
