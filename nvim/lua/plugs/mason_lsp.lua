local utils = require("utils")

local function get_lsp_conf(default_conf, server_name)
    local result, custom_conf = pcall(require, "language_servers/" .. server_name)
    if not result or not custom_conf then
        return default_conf
    end

    return custom_conf
end

local function setup_lsp(server_names)
    local lspconfig = require("lspconfig")
    for _, server_name in ipairs(server_names) do
        local server = lspconfig[server_name]
        if server then
            local server_conf = get_lsp_conf(server, server_name)

            local capabilities = server_conf.capabilities or {}
            capabilities.offsetEncoding = { "utf-16" }
            server_conf.capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            server_conf.on_attach = function(client, bufnr)
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

            server.setup(server_conf)

            -- Run the post_setup function if it exists
            if server_conf.post_setup then
                server_conf.post_setup()
            end
        else
            error("LSP server not found: " .. server_name)
        end
    end
end

local are_stepping_keymaps_active = false
local function setup_dap()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()
    require("persistent-breakpoints").setup {
        load_breakpoints_event = { "BufReadPost" }
    }

    local stepping_keymaps = {
        n = {
            ["m"] = {
                cmd = function()
                    dap.step_out()
                end
            },
            ["n"] = {
                cmd = function()
                    dap.step_over()
                end
            },
            ["i"] = {
                cmd = function()
                    dap.step_into()
                end
            },
        }
    }

    local function enter_debug_mode()
        dapui.open()
        if not are_stepping_keymaps_active then
            utils.add_keymaps(stepping_keymaps)
            are_stepping_keymaps_active = true
        end
    end

    local function exit_debug_mode()
        dapui.close()
        if are_stepping_keymaps_active then
            utils.remove_keymaps(stepping_keymaps)
            are_stepping_keymaps_active = false
        end
    end

    local dap_signs = {
        { "DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" } },
        { "DapBreakpointRejected", { text = "🔵", texthl = "", linehl = "", numhl = "" } },
        { "DapBreakpointCondition", { text = "🟥", texthl = "", linehl = "", numhl = "" } },
    }

    for _, sign in ipairs(dap_signs) do
        vim.fn.sign_define(unpack(sign))
    end

    dap.listeners.after.event_initialized["dapui_config"] = function()
        enter_debug_mode()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        exit_debug_mode()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        exit_debug_mode()
    end

    require("mason-nvim-dap").setup({
        handlers = {}
    })
    require("nvim-dap-repl-highlights").setup()
    require("nvim-dap-virtual-text").setup()

    local breakpoint_api = require("persistent-breakpoints.api")
    utils.add_keymaps({
        n = {
            ["<leader>dr"] = {
                cmd = function()
                    dap.continue()
                end
            },
            ["<leader>bt"] = {
                cmd = function()
                    breakpoint_api.toggle_breakpoint()
                end
            },
            ["<leader>bc"] = {
                cmd = function()
                    breakpoint_api.set_conditional_breakpoint()
                end
            },
            ["<leader>br"] = { -- breakpoint remove
                cmd = function()
                    breakpoint_api.clear_all_breakpoints()
                end
            },
            ["<leader>ds"] = {
                cmd = function()
                    dap.disconnect({ terminateDebuggee = true })
                    dap.close()
                    exit_debug_mode()
                end
            },
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
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",

        -- DAP
        "jay-babu/mason-nvim-dap.nvim",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap",
        { "nvim-neotest/nvim-nio", lazy = true },
        "LiadOz/nvim-dap-repl-highlights",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        {
            "LarssonMartin1998/nvim-dap-profiles",
            opts = {},
        },
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
        local custom_server_confs = vim.tbl_map(function(file)
            return vim.fn.fnamemodify(file, ":t:r")
        end, lua_files)

        -- Combine the default servers with the custom ones
        local server_names = vim.list_extend({
            "bashls",
            "cmake",
            "lua_ls",
            "yamlls",
            "zls",
            -- "ocamllsp",
            "gopls",
        }, custom_server_confs)

        -- Create a new table which contains the non LSP Mason installees.
        -- IMPORTANT: Make sure to leave rust-analyzer out of this list, as it can cause conflicts with rustaceanvim.
        -- Install rust-analyzer using your systems package manager instead.
        local mason_installs = vim.list_extend({
            "clang-format",
            "codelldb",
            "netcoredbg",
            "delve",
            "golangci-lint",
            -- "ocamlearlybird",
            -- "ocamlformat",
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
