local function switch_between_header_and_source(bufnr)
    local util = require("lspconfig/util")
    bufnr = util.validate_bufnr(bufnr)
    local clangd_client = util.get_active_client_by_name(bufnr, "clangd")
    local params = { uri = vim.uri_from_bufnr(bufnr) }
    -- invert this with an early return
    if not clangd_client then
        print "method textDocument/switchSourceHeader is not supported by any servers active on the current buffer"
        return
    end

    clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            print("Corresponding file cannot be determined")
            return
        end
        vim.api.nvim_command("drop " .. vim.uri_to_fname(result))
    end, bufnr)
end

local M = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=bundled",
        -- "--cross-file-rename", // This has been deprecated
        "--rename-file-limit=0",
        "--header-insertion=iwyu",
        "--inlay-hints",
        -- "--compile-commands-dir=build/",
    },
    commands = {
        ClangdSwitchSourceHeader = {
            function()
                switch_between_header_and_source(0)
            end,
            description = "Switch between source/header",
        },
    },
}

function M.post_setup()
    require("utils").add_keymaps({
        n = {
            ["<leader>ko"] = { cmd = ":ClangdSwitchSourceHeader<CR>" }
        },
    })
end

return M
