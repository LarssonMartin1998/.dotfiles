local M = {}

function M.add_keymaps(maps)
    for mode, entries in pairs(maps) do
        for code, info in pairs(entries) do
            vim.keymap.set(mode, code, info.cmd, info.opts)
        end
    end
end

return M
