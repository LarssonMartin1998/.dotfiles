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

-- Find all files in lua/language_servers and require them
-- We use them to ensure that the servers are installed and configured
local lua_files_str = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/language_servers", "*.lua", true)
local has_line_breaks = vim.fn.match(lua_files_str, [[\n]]) > -1
-- Get an array of all the files in the directory, make sure to account for single file
local lua_files = has_line_breaks and vim.fn.split(lua_files_str, "\n") or { lua_files_str }
-- Remove path and extension and only keep the filename
local server_names = vim.tbl_map(function(file)
    return vim.fn.fnamemodify(file, ":t:r")
end, lua_files)

local errors = {}
utils.foreach(server_names, function(server_name)
    local path = "language_servers/" .. server_name
    local result, conf = utils.xpcallmsg(
        function() return require(path) end,
        "Failed to require " .. path,
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
