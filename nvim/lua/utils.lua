local M = {}

function M.set_keymap_list(keymap_list, mode)
    mode = mode or "n"
    for _, mapping in ipairs(keymap_list) do
        vim.keymap.set(mode, mapping[1], mapping[2], mapping[3] or {})
    end
end

function M.del_keymap_list(keymap_list, mode)
    mode = mode or "n"
    for _, mapping in ipairs(keymap_list) do
        vim.keymap.del(mode, mapping[1])
    end
end

function M.validate_bufnr(bufnr)
    vim.validate('bufnr', bufnr, 'number')
    return bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
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

            if vim.bo[current_buf].filetype == filetype then
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
