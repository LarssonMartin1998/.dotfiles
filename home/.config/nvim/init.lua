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

-- Set configs for servers and enable them in the Neovim LSP Client
require("lsp/setup")

-- Set configs for nvim-dap so we can debug
require("dap/setup")

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()

--[[
-- Annoyanes in config:
-- 1. codelldb doesn't terminate C++ program after debugging.    : Don't know how to fix, have asked for help.
-- 2. Fix so you can close code action window with <EscUse rounded corners with arrow.>
-- 3. Fix so you can use <Esc> and q to close hover_doc window without entering it.
--]]
