local M = {}

M.hints_active = true
M.buffers = {}

function M.add_buffer(bufnr)
    table.insert(M.buffers, bufnr)

    vim.lsp.inlay_hint.enable(M.hints_active, { bufnr = bufnr })
    vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
        buffer = bufnr,
        callback = function()
            for i, buffer in ipairs(M.buffers) do
                if buffer == bufnr then
                    table.remove(M.buffers, i)
                    break
                end
            end
        end,
    })
end

function M.disable()
    for _, bufnr in ipairs(M.buffers) do
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end
end

function M.restore()
    for _, bufnr in ipairs(M.buffers) do
        vim.lsp.inlay_hint.enable(M.hints_active, { bufnr = bufnr })
    end
end

return M
