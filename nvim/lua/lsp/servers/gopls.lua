local mod_cache = nil

return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            ["ui.inlayhints.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true,
            },
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            lintTool = "golangci-lint",
        },
    },
    root_dir = function(callback)
        local path = vim.fn.expand("%:p")
        if not path or path == "" then
            callback(nil)
            return
        end

        -- Asynchronously fetch GOMODCACHE if not already set
        if not mod_cache then
            vim.system({ "go", "env", "GOMODCACHE" }, { text = true }, function(result)
                if result and result.code == 0 and result.stdout then
                    mod_cache = vim.trim(result.stdout)
                else
                    vim.notify("[gopls] Unable to fetch GOMODCACHE", vim.log.levels.WARN)
                    mod_cache = nil
                end
            end)
        end

        -- Check if the file is in the module cache
        if mod_cache and path:sub(1, #mod_cache) == mod_cache then
            local clients = vim.lsp.get_clients({ name = "gopls" })
            if #clients > 0 then
                callback(clients[#clients].config.root_dir)
                return
            end
        end

        -- Fallback: Find project root markers
        local go_mod_root = vim.fs.find({ "go.work", "go.mod", ".git" }, { upward = true, path = path })[1]
        if go_mod_root then
            callback(vim.fs.dirname(go_mod_root))
        else
            callback(nil)
        end
    end,
}
