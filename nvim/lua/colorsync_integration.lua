local filepath = vim.fs.joinpath(os.getenv("HOME"), ".local/state/colorsync/current")

vim.api.nvim_create_augroup("ColorsyncEvents", { clear = true })

local handle = vim.uv.new_fs_event()
if not handle then
    vim.notify("colorsync: failed to create fs event handle", vim.log.levels.ERROR)
    return
end

handle:start(filepath, {}, function(err)
    if err then
        vim.schedule(function()
            vim.notify("colorsync: error watching " .. filepath .. "\n" .. err, vim.log.levels.ERROR)
        end)
        return
    end

    vim.schedule(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "ColorsyncThemeChanged", modeline = false })
    end)
end)
