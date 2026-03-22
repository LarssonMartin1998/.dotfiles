local function ts_select(query)
    return function() require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects") end
end

local function ts_move_prev(query)
    return function() require("nvim-treesitter-textobjects.move").goto_previous_start(query, "textobjects") end
end

local function ts_move_next(query)
    return function() require("nvim-treesitter-textobjects.move").goto_next_start(query, "textobjects") end
end

-- TODO: Move away from master branch after updating to Neovim 0.12 and use the rewrite
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    branch = "master",
    build = ":TSUpdate",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                max_lines = 2,           -- How many lines the window should span. Values <= 0 mean no limit.
                multiline_threshold = 3, -- Maximum number of lines to show for a single context
                trim_scope = "inner",    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            }
        },
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            init = function()
                -- Disable entire built-in ftplugin mappings to avoid conflicts.
                -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
                vim.g.no_plugin_maps = true
            end,
            opts = {
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            },
            keys = {
                -- select
                { "ic", ts_select("@class.inner"),          mode = { "x", "o" } },
                { "ac", ts_select("@class.outer"),          mode = { "x", "o" } },
                { "ii", ts_select("@conditional.inner"),    mode = { "x", "o" } },
                { "ai", ts_select("@conditional.outer"),    mode = { "x", "o" } },
                { "if", ts_select("@function.inner"),       mode = { "x", "o" } },
                { "af", ts_select("@function.outer"),       mode = { "x", "o" } },
                { "il", ts_select("@loop.inner"),           mode = { "x", "o" } },
                { "al", ts_select("@loop.outer"),           mode = { "x", "o" } },
                { "ia", ts_select("@attribute.inner"),      mode = { "x", "o" } },
                { "aa", ts_select("@attribute.outer"),      mode = { "x", "o" } },
                -- move
                { "[f", ts_move_prev("@function.outer"),    mode = { "n", "x", "o" } },
                { "[i", ts_move_prev("@conditional.outer"), mode = { "n", "x", "o" } },
                { "[c", ts_move_prev("@class.outer"),       mode = { "n", "x", "o" } },
                { "[l", ts_move_prev("@loop.outer"),        mode = { "n", "x", "o" } },
                { "]f", ts_move_next("@function.outer"),    mode = { "n", "x", "o" } },
                { "]i", ts_move_next("@conditional.outer"), mode = { "n", "x", "o" } },
                { "]c", ts_move_next("@class.outer"),       mode = { "n", "x", "o" } },
                { "]l", ts_move_next("@loop.outer"),        mode = { "n", "x", "o" } },
            },
        },
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
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
                "dap_repl",
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
                "jsonc",
            },
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        })
    end
}
