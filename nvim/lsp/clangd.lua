local utils = require("utils")

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header()
    local bufnr = utils.validate_bufnr(0)
    local clangd_client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
    if clangd_client then
        clangd_client.request(
            "textDocument/switchSourceHeader",
            { uri = vim.uri_from_bufnr(bufnr) },
            function(err, result)
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

return {
    cmd = {
        "clangd",
        "--background-index",         -- Enables background indexing
        "--clang-tidy",               -- Enables clang-tidy diagnostics
        "--completion-style=bundled", -- Simpler completions for faster performance
        "--rename-file-limit=0",      -- No limit on renaming files
        "--header-insertion=iwyu",    -- Suggest missing includes based on IWYU
        "--limit-results=70",         -- Limit autocompletion and symbol results
        "--pch-storage=disk",         -- Stores precompiled headers on disk (fixes the issue where system ran out of memory when indexing large projects, not a huge performance hit on fast m2 ssds)
        "--log=error",                -- Log only errors
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
    },
    on_attach = function()
        utils.set_keymap_list({
            { "<leader>h", switch_source_header, },
        })
    end,
}
