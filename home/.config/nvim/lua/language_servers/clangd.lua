local util = require "lspconfig.util"

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
    bufnr = util.validate_bufnr(bufnr)
    local clangd_client = util.get_active_client_by_name(bufnr, "clangd")
    local params = { uri = vim.uri_from_bufnr(bufnr) }
    if clangd_client then
        clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
            if err then
                error(tostring(err))
            end
            if not result then
                print "Corresponding file cannot be determined"
                return
            end
            vim.api.nvim_command("drop " .. vim.uri_to_fname(result))
        end, bufnr)
    else
        print "method textDocument/switchSourceHeader is not supported by any servers active on the current buffer"
    end
end

local function symbol_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local clangd_client = util.get_active_client_by_name(bufnr, "clangd")
    if not clangd_client or not clangd_client.supports_method "textDocument/symbolInfo" then
        return vim.notify("Clangd client not found", vim.log.levels.ERROR)
    end
    local params = vim.lsp.util.make_position_params()
    clangd_client.request("textDocument/symbolInfo", params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is not reason to parse it
            return
        end
        local container = string.format("container: %s", res[1].containerName) ---@type string
        local name = string.format("name: %s", res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, "", {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            border = require("lspconfig.ui.windows").default_options.border or "single",
            title = "Symbol Info",
        })
    end, bufnr)
end

local lsp_maps = {
    {
        "<leader>ko",
        function() switch_source_header(0) end,
    },
    {
        "K",
        symbol_info,
    }
}
local keymaps = { n = {} }
for i, _ in ipairs(lsp_maps) do
    local binding, cmd = unpack(lsp_maps[i])
    keymaps.n[binding] = { cmd = cmd }
end
require("utils").add_keymaps(keymaps)

local root_files = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
}

local default_capabilities = {
    textDocument = {
        completion = {
            editsNearCursor = true,
        },
    },
    offsetEncoding = { "utf-16" },
}

return {
    cmd = {
        "clangd",
        "--background-index",         -- Enables background indexing
        "--clang-tidy",               -- Enables clang-tidy diagnostics
        "--completion-style=bundled", -- Simpler completions for faster performance
        "--rename-file-limit=0",      -- No limit on renaming files
        "--header-insertion=iwyu",    -- Suggest missing includes based on IWYU
        "--inlay-hints",              -- Enable inlay hints for parameter and type information
        "--limit-results=70",         -- Limit autocompletion and symbol results
        "--suggest-missing-includes", -- Still show missing includes suggestions
        "--pch-storage=disk",         -- Stores precompiled headers on disk (fixes the issue where system ran out of memory when indexing large projects, not a huge performance hit on fast m2 ssds)
        "--log=error",                -- Log only errors
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    capabilities = default_capabilities,
    docs = {
        description = [[
https://clangd.llvm.org/installation.html

- **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lsp/issues/23).
- If `compile_commands.json` lives in a build directory, you should
  symlink it to the root of your source tree.
    ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
- clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson
]],
        default_config = {
            root_dir =
            [[      root_pattern(        ".clangd",        ".clang-tidy",        ".clang-format",        "compile_commands.json",        "compile_flags.txt",        "configure.ac",        ".git"      )    ]],
            capabilities = [[default capabilities, with offsetEncoding utf-8]],
        },
    },
}