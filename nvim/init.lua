-- Load keymaps before loading any plugins
require("keymaps")

-- Change and personalize native vim settings
vim.opt = require("vim_opt")

-- Initialize Lazy package manager
require("lazy_init")

-- Initialize the sticky terminal window at the bottom
require("terminal")

-- Initialize the custom window management functionality
require("window_management").setup()

-- Initializes custom commands and keybindings for handling code formatting
require("format_handler").setup()

-- Initialize the custom close handler for handling window closing events
require("close_handler").setup()

-- Set configs for servers and enable them in the Neovim LSP Client
require("lspsetup")

-- Set configs for nvim-dap so we can debug
require("dapsetup")

-- Change built in settings related to diagnostics
require("diagnostics")

--[[
-- Annoyances in Neovim environment:
-- 1. codelldb doesn't terminate C++ program after debugging.    : Don't know how to fix, have asked for help.
-- 2. Sometimes very seldomly the cursor stops rendering, the only fix I found is to restart Neovim.
-- 3. Remove usage of dap-go, dap-python, and rustaceanvim. These are really just providing DAP/LSP configs which I prefer to have without plugin bloat. However, they require more to setup than your average conf.
--]]
