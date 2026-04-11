local utils = require("utils")
local inlay_hints_handler = require("inlay_hints_handler")

local format_on_save = true

vim.api.nvim_create_user_command("FormatEnable", function() format_on_save = true end, {})
vim.api.nvim_create_user_command("FormatDisable", function() format_on_save = false end, {})
vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format() end, {})

vim.lsp.config("*", {
    root_markers = { ".git" },
})

local servers = {}
local lsp_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp")
for name, type in vim.fs.dir(lsp_dir) do
    if type == "file" and name:match("%.lua$") then
        table.insert(servers, (name:gsub("%.lua$", "")))
    end
end

local lsp_pick_ns = vim.api.nvim_create_namespace("lsp_pick")
local function lsp_pick(fn)
    local opts = {
        on_list = function(options)
            if #options.items == 1 then
                local item = options.items[1]
                vim.cmd("normal! m'")
                vim.cmd.drop(item.filename)
                if item.lnum <= vim.api.nvim_buf_line_count(0) then
                    vim.api.nvim_win_set_cursor(0, { item.lnum, (item.col or 1) - 1 })
                end
                return
            end
            local cwd = (vim.uv.cwd() or "") .. "/"
            local home = (vim.env.HOME or "") .. "/"
            for _, item in ipairs(options.items) do
                local icon, icon_hl = MiniIcons.get("file", item.filename)
                local rel = item.filename
                if rel:sub(1, #cwd) == cwd then
                    rel = rel:sub(#cwd + 1)
                elseif rel:sub(1, #home) == home then
                    rel = "~/" .. rel:sub(#home + 1)
                end
                local prefix = string.format("%s:%d:%d:", rel, item.lnum, item.col or 0)
                item.path = item.filename
                item.icon_hl = icon_hl
                item.icon_end = #icon
                item.prefix_end = #icon + 1 + #prefix
                item.text = string.format("%s %s  %s", icon, prefix, vim.trim(item.text or ""))
            end
            MiniPick.start({
                source = {
                    name = "LSP",
                    items = options.items,
                    show = function(buf_id, items_to_show, query)
                        MiniPick.default_show(buf_id, items_to_show, query)
                        vim.api.nvim_buf_clear_namespace(buf_id, lsp_pick_ns, 0, -1)
                        for i, item in ipairs(items_to_show) do
                            vim.api.nvim_buf_set_extmark(buf_id, lsp_pick_ns, i - 1, 0, {
                                end_col = item.icon_end,
                                hl_group = item.icon_hl,
                                priority = 200,
                            })
                            vim.api.nvim_buf_set_extmark(buf_id, lsp_pick_ns, i - 1, item.icon_end + 1, {
                                end_col = item.prefix_end,
                                hl_group = "Comment",
                                priority = 200,
                            })
                        end
                    end,
                    preview = MiniPick.default_preview,
                    choose = MiniPick.default_choose,
                },
            })
        end,
    }
    fn(opts)
end

vim.lsp.enable(servers)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        assert(client, "LspAttach: client is nil")

        inlay_hints_handler.add_buffer(bufnr)

        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = 0 })
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    if format_on_save then vim.lsp.buf.format() end
                end,
            })
        end

        for mode, keys in pairs({
            n = {
                { "K",         function() vim.lsp.buf.hover() end,         { buf = bufnr } },
                { "<leader>a", function() vim.lsp.buf.code_action() end,   { buf = bufnr } },
                { "gd",        function() lsp_pick(vim.lsp.buf.definition) end,                               { buf = bufnr } },
                { "gD",        function() lsp_pick(vim.lsp.buf.declaration) end,                              { buf = bufnr } },
                { "gr",        function() lsp_pick(function(opts) vim.lsp.buf.references(nil, opts) end) end, { buf = bufnr, nowait = true } },
                { "gi",        function() lsp_pick(vim.lsp.buf.implementation) end,                          { buf = bufnr } },
                { "gt",        function() lsp_pick(vim.lsp.buf.type_definition) end,                         { buf = bufnr } },
            },
            i = {
                { "<C-s>", function() vim.lsp.buf.signature_help() end, { buf = bufnr } },
            },
        }) do
            utils.set_keymap_list(keys, mode)
        end
    end,
})
