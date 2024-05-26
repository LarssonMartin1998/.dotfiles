local M = {}

function M.add_keymaps(maps)
    for mode, entries in pairs(maps) do
        for code, info in pairs(entries) do
            vim.keymap.set(mode, code, info.cmd, info.opts)
        end
    end
end

function M.get_bufnr_for_filetype(filetype)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == filetype then
            return buf
        end
    end

    return nil
end

function M.is_buf_filetype(bufnr, filetype)
    return vim.bo[bufnr].filetype == filetype
end

return M
