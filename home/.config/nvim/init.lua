local function setup_yank_highlight()
    vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#e0af68" })
    local yank_autocommand = vim.api.nvim_create_augroup("YankHighlightAutocommand", { clear = true })

    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                timeout = 250,
                higroup = "YankHighlight",
            })
        end,
        group = yank_autocommand,
    })
end

-- Load keymaps before loading any plugins
require("keymaps")

-- change and personalize native vim settings
vim.opt = require("vim_opt")

-- Initialize Lazy package manager
require("lazy_init")

-- Initialize the sticky terminal window at the bottom
require("terminal")

-- Initialize the custom window management functionality
require("window_management").setup()

-- Initializes custom commands and keybindings for handling code formatting
require("format_handler").setup()

-- Set configs for servers and enable them in the Neovim LSP Client
require("lsp/setup")

-- Set configs for nvim-dap so we can debug
require("dap/setup")

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()

--[[
-- Annoyances in Neovim environment:
-- 1. codelldb doesn't terminate C++ program after debugging.    : Don't know how to fix, have asked for help.
-- 2. Sometimes very seldomly the cursor stops rendering, the only fix I found is to restsart Neovim.
-- 3. Add PR to lspsaga for always jumping into the hover_dock immediately.
-- 4. Add PR to lspsaga so you can add keybindings for closing hover_doc, rename, finder, incoming_calls, and code actions using many configurable keybindings. I'm after "<Esc>" and "q".
--]]
