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

utils.set_keymap_list({
    { "<leader>f", function()
        MiniPick.builtin.cli(
            { command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" } },
            { source = { name = "Files", show = MiniPick.default_show } }
        )
    end },
    { "<leader>g", function() MiniPick.builtin.grep_live() end },
    { "<leader>b", function() MiniPick.builtin.buffers() end },
    { "<leader>o", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end },
    { "<leader>s", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end },
    { "<leader>n", function() MiniNotify.show_history() end },
    { "<leader>x", function() MiniExtra.pickers.diagnostic({ win = { preview = { wo = { wrap = true } } } }) end },
})
