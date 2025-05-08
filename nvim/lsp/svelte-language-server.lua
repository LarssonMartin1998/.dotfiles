-- Helper function for the 'MigrateToSvelte5' LSP command.
-- This function will be called by the user command created in on_attach.
local function migrate_to_svelte_5_command(client)
    client:exec_param({
        command = "migrate_to_svelte_5",
        arguments = { vim.uri_from_bufnr(vim.api.nvim_get_current_buf()) },
    })
end

return {
    cmd = { "svelteserver", "--stdio" },

    filetypes = { "svelte" },

    root_markers = { "package.json", ".git/" },
    on_attach = function(client, bufnr)
        local fn = function() migrate_to_svelte_5_command(client) end
        vim.api.nvim_buf_create_user_command(bufnr, "SvelteMigrateToSvelte5", fn, {
            desc = "Svelte: Migrate Component to Svelte 5 Syntax (via LSP).",
        })
    end,
}
