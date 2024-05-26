local M = {}

function M.add_keymaps(maps)
    for mode, entries in pairs(maps) do
        for code, info in pairs(entries) do
            vim.keymap.set(mode, code, info.cmd, info.opts)
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
