local utils = require("utils")

local function setup_lsp(server_names)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")
    for _, server_name in ipairs(server_names) do
        local server = lspconfig[server_name]
        if server then
            local server_table = require("language_servers/" .. server_name)
            capabilities.textDocument.completion.completionItem.snippetSupport = false
            server_table.capabilities = capabilities
            server_table.on_attach = function(client, bufnr)
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
                                silent = true
                            }
                        },
                        ["gD"] = {
                            cmd = function()
                                vim.lsp.buf.declaration()
                            end,
                            opts = {
                                noremap = true,
                                silent = true
                            }
                        },
                    }
                })
            end

            server.setup(server_table)

            -- Run the post_setup function if it exists
            if server_table.post_setup then
                server_table.post_setup()
            end
        else
            error("LSP server not found: " .. server_name)
        end
    end
end

local function setup_dap()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()

    local dap_signs = {
        { "DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" } },
    }

    for _, sign in ipairs(dap_signs) do
        vim.fn.sign_define(sign[1], sign[2])
    end

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    require("mason-nvim-dap").setup({
        handlers = {}
    })
    require("nvim-dap-repl-highlights").setup()
    require("nvim-dap-virtual-text").setup()

    utils.add_keymaps({
        n = {
            ["<leader>dr"] = { cmd = ":lua require(\"dap\").continue()<CR>" },
            ["<leader>db"] = { cmd = ":lua require(\"dap\").toggle_breakpoint()<CR>" },
            ["<leader>ds"] = {
                cmd = function()
                    dap.disconnect({ terminateDebuggee = true })
                    dap.close()
                    dapui.close()
                end
            },
            ["<F10>"] = { cmd = ":lua require(\"dap\").step_over()<CR>" },
            ["<F11>"] = { cmd = ":lua require(\"dap\").step_into()<CR>" },
            ["<F12>"] = { cmd = ":lua require(\"dap\").step_out()<CR>" },
        }
    })
end

return {
    "williamboman/mason.nvim",
    dependencies = {
        -- Mason plugins
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "RubixDev/mason-update-all",

        -- LSP config
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",

        -- DAP
        "folke/neodev.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "LiadOz/nvim-dap-repl-highlights",
        "theHamsta/nvim-dap-virtual-text"
    },
    config = function()
        -- Find all files in lua/language_servers and require them
        -- We use them to ensure that the servers are installed and configured
        -- Make sure that the files use the lspconfig naming convention
        local lua_files_str = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/language_servers", "*.lua", true)
        local has_line_breaks = vim.fn.match(lua_files_str, [[\n]]) > -1
        -- Get an array of all the files in the directory, make sure to account for single file
        local lua_files = has_line_breaks and vim.fn.split(lua_files_str, "\n") or { lua_files_str }
        -- Remove path and extension and only keep the filename
        local server_names = vim.tbl_map(function(file)
            return vim.fn.fnamemodify(file, ":t:r")
        end, lua_files)

        -- Create a new table which contains the non-lsp setups for Mason (linters, formatters, etc)
        -- IMPORTANT: Make sure to leave rust-analyzer out of this list, as it can cause conflicts with rustaceanvim.
        -- Install rust-analyzer using your systems package manager instead.
        local mason_installs = vim.list_extend({
            "clang-format",
            "cmakelang",
            "codelldb",
            "netcoredbg",
        }, server_names)

        require("mason").setup()
        require("mason-lspconfig").setup()
        require("mason-tool-installer").setup({
            ensure_installed = mason_installs,
        })

        setup_lsp(server_names)
        setup_dap()

        require("mason-update-all").setup()
    end,
}
