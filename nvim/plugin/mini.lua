local utils = require("utils")

require("mini.icons").setup({})
-- mock_nvim_web_devicons() shims the devicons API so plugins that require it continue to work without the real package.
MiniIcons.mock_nvim_web_devicons()

require("mini.notify").setup({})
vim.notify = MiniNotify.make_notify()

require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
    draw = {
        animation = require("mini.indentscope").gen_animation.none(),
    },
})

require("mini.sessions").setup({
    autowrite = true,
})

require("mini.surround").setup({
    custom_surroundings = {
        ["("] = { output = { left = "(", right = ")" } },
        ["{"] = { output = { left = "{", right = "}" } },
        ["<"] = { output = { left = "<", right = ">" } },
        ["["] = { output = { left = "[", right = "]" } },
    },
    mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        find = "",
        find_left = "",
        highlight = "",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
    },
    search_method = "cover_or_next",
})
utils.del_keymap_list({ { "ys" } }, "x")
utils.set_keymap_list({
    { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true } },
}, "x")
-- yss, surround current line
utils.set_keymap_list({
    { "yss", "ys_", { remap = true } },
})

local starter = require("mini.starter")
starter.setup({
    items = {
        starter.sections.recent_files(8, false),
        {
            { name = "Find File",      action = "lua MiniPick.builtin.files()",     section = "Actions" },
            { name = "Live Grep",      action = "lua MiniPick.builtin.grep_live()", section = "Actions" },
            { name = "New File",       action = "ene | startinsert",                section = "Actions" },
            { name = "Sessions",       action = "lua MiniSessions.select()",        section = "Actions" },
            { name = "Update Plugins", action = "lua vim.pack.update()",            section = "Actions" },
            { name = "Quit",           action = "qa",                               section = "Actions" },
        },
    },
    content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning("center", "center"),
    },
})

require("mini.diff").setup({})
utils.set_keymap_list({
    { "[g",        function() MiniDiff.goto_hunk("prev") end },
    { "]g",        function() MiniDiff.goto_hunk("next") end },
    { "<leader>c", function() MiniDiff.toggle_overlay(0) end },
})

require("mini.cursorword").setup({})

-- mini modules reset their highlight groups during setup(), so re-apply
-- the norrsken integration after setup and again on ColorScheme change.
local apply_mini_hl = require("norrsken.integrations.mini")
apply_mini_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_mini_hl })

require("mini.pick").setup({})
require("mini.extra").setup()

local workspace_symbols_ns = vim.api.nvim_create_namespace("workspace_symbols_pick")

utils.set_keymap_list({
    { "<leader>f", function()
        MiniPick.builtin.cli(
            { command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" } },
            { source = { name = "Files", show = MiniPick.default_show } }
        )
    end },
    { "<leader>g", function() MiniPick.builtin.grep_live() end },
    { "<leader>b", function() MiniPick.builtin.buffers() end },
    { "<leader>o", function()
        local cwd = (vim.uv.cwd() or "") .. "/"
        local home = (vim.env.HOME or "") .. "/"
        local bufnr = vim.api.nvim_get_current_buf()
        MiniPick.start({
            source = {
                name = "Workspace Symbols",
                items = function()
                    local items = {}
                    local results = vim.lsp.buf_request_sync(bufnr, "workspace/symbol", { query = "" }, 5000)
                    if not results then return items end
                    for _, response in pairs(results) do
                        for _, symbol in ipairs(response.result or {}) do
                            local loc = symbol.location
                            if loc then
                                local path = vim.uri_to_fname(loc.uri)
                                local rel = path
                                local sort_prio
                                if rel:sub(1, #cwd) == cwd then
                                    rel = rel:sub(#cwd + 1)
                                    sort_prio = 1
                                elseif rel:sub(1, #home) == home then
                                    rel = "~/" .. rel:sub(#home + 1)
                                    sort_prio = 2
                                else
                                    rel = vim.fn.fnamemodify(path, ":t")
                                    sort_prio = 3
                                end
                                local lnum = loc.range.start.line + 1
                                local col = loc.range.start.character + 1
                                local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "?"
                                local icon, icon_hl = MiniIcons.get("lsp", kind)
                                local prefix = string.format("%s:%d:%d:", rel, lnum, col)
                                table.insert(items, {
                                    text = string.format("%s %s  %s", icon, prefix, symbol.name),
                                    icon_hl = icon_hl,
                                    icon_end = #icon,
                                    prefix_end = #icon + 1 + #prefix,
                                    sort_prio = sort_prio,
                                    path = path,
                                    lnum = lnum,
                                    col = col,
                                })
                            end
                        end
                    end
                    table.sort(items, function(a, b) return a.sort_prio < b.sort_prio end)
                    return items
                end,
                show = function(buf_id, items_to_show, query)
                    MiniPick.default_show(buf_id, items_to_show, query)
                    vim.api.nvim_buf_clear_namespace(buf_id, workspace_symbols_ns, 0, -1)
                    for i, item in ipairs(items_to_show) do
                        vim.api.nvim_buf_set_extmark(buf_id, workspace_symbols_ns, i - 1, 0, {
                            end_col = item.icon_end,
                            hl_group = item.icon_hl,
                            priority = 200,
                        })
                        vim.api.nvim_buf_set_extmark(buf_id, workspace_symbols_ns, i - 1, item.icon_end + 1, {
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
    end },
    { "<leader>s", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end },
    { "<leader>n", function() MiniNotify.show_history() end },
    { "<leader>x", function() MiniExtra.pickers.diagnostic({ win = { preview = { wo = { wrap = true } } } }) end },
})
