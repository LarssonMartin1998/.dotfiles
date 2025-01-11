local utils = require("utils")

local function chain_on_attach(...)
    local funcs = { ... }
    return function(client, bufnr)
        for _, func in ipairs(funcs) do
            func(client, bufnr)
        end
    end
end

local function global_on_attach(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = 0 })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end

    utils.add_keymaps({
        n = {
            ["gd"] = {
                cmd = function()
                    vim.lsp.buf.definition()
                end,
                opts = {
                    noremap = true,
                    silent = true,
                    buffer = bufnr
                }
            },
            ["gD"] = {
                cmd = function()
                    vim.lsp.buf.declaration()
                end,
                opts = {
                    noremap = true,
                    silent = true,
                    buffer = bufnr
                }
            },
        }
    })
end

local global_capabilities = require("blink.cmp").get_lsp_capabilities()
global_capabilities.offsetEncoding = { "utf-16" }

vim.diagnostic.config({
    underline = true,        -- Underline diagnostic errors
    virtual_text = false,    -- Disable inline text messages
    signs = true,            -- Show icons in the sign column
    update_in_insert = true, -- Update diagnostics during insert mode
})

vim.lsp.config("*", {
    capabilities = global_capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.diagnostic.on_publish_diagnostics,
    },
    root_markers = { ".git" },
})

-- Find all files in lua/lsp/servers and require them
-- We use them to ensure that the servers are installed and configured
local errors = {}
local dir_path = "lsp/servers"
utils.foreach(utils.get_file_names_in_dir(dir_path, "*.lua", true), function(server_name)
    local server_path = dir_path .. "/" .. server_name
    local result, conf = utils.xpcallmsg(
        function() return require(server_path) end,
        "Failed to require " .. server_path,
        errors
    )

    if not result or type(conf) ~= "table" or vim.tbl_isempty(conf) or conf.cmd == nil then
        error("Invalid configuration for " .. server_name)
        return
    end

    conf.on_attach = (function()
        if conf.on_attach then
            return chain_on_attach(global_on_attach, conf.on_attach)
        end

        return global_on_attach
    end)()

    -- These still throw errors when wrapped by xpcall.
    -- Wanted it to just handle incorrect input and let the runtime continue
    -- as it would if the require was successful when wrapped. That would be great
    -- for WIP LSP configuration, instead we have the ugly if statements above.
    vim.lsp.config(server_name, conf)
    vim.lsp.enable(server_name)
end)

if #errors > 0 then
    error(table.concat(errors, "\n"))
end
