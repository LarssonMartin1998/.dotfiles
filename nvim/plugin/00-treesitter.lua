vim.g.no_plugin_maps = true -- must be set before plugin loads

-- Rewrite API: configs.setup() is gone. Highlighting is handled by Neovim 0.12 builtins.
-- install() skips already-installed parsers automatically.
vim.schedule(function()
    require("nvim-treesitter.install").install({
        "vim",
        "vimdoc",
        "bash",
        "lua",
        "c",
        "cpp",
        "c_sharp",
        "rust",
        "cmake",
        "make",
        "yaml",
        "ninja",
        "gitignore",
        "markdown",
        "markdown_inline",
        "hyprlang",
        "json",
        "html",
        "hlsl",
        "glsl",
        "gdshader",
        "gdscript",
        "dockerfile",
        "dart",
        "go",
        "zig",
        "css",
        "regex",
        "muttrc",
        "python",
        "latex",
        "typst",
        "ruby",
        "svelte",
        "typescript",
        "just",
        "tsx",
        "javascript",
    })
end)

require("treesitter-context").setup({
    max_lines = 2,
    multiline_threshold = 3,
    trim_scope = "inner",
})

-- Textobject helpers
local function ts_select(query)
    return function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end
end
local function ts_move_prev(query)
    return function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(query, "textobjects")
    end
end
local function ts_move_next(query)
    return function()
        require("nvim-treesitter-textobjects.move").goto_next_start(query, "textobjects")
    end
end

require("nvim-treesitter-textobjects").setup({
    select = { lookahead = true },
    move = { set_jumps = true },
})

local utils = require("utils")

-- Textobject select keymaps
for _, mode_maps in ipairs({
    {
        { "x", "o" },
        {
            { "ic", ts_select("@class.inner") },
            { "ac", ts_select("@class.outer") },
            { "ii", ts_select("@conditional.inner") },
            { "ai", ts_select("@conditional.outer") },
            { "if", ts_select("@function.inner") },
            { "af", ts_select("@function.outer") },
            { "il", ts_select("@loop.inner") },
            { "al", ts_select("@loop.outer") },
            { "ia", ts_select("@parameter.inner") },
            { "aa", ts_select("@parameter.outer") },
        },
    },
    {
        { "n", "x", "o" },
        {
            { "[f", ts_move_prev("@function.outer") },
            { "[i", ts_move_prev("@conditional.outer") },
            { "[c", ts_move_prev("@class.outer") },
            { "[l", ts_move_prev("@loop.outer") },
            { "]f", ts_move_next("@function.outer") },
            { "]i", ts_move_next("@conditional.outer") },
            { "]c", ts_move_next("@class.outer") },
            { "]l", ts_move_next("@loop.outer") },
        },
    },
}) do
    utils.set_keymap_list(mode_maps[2], mode_maps[1])
end
