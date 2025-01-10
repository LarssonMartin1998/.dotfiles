local function setup_yank_highlight()
    -- Create a new highlight group which will be used for yank highlighting with the name "YankHighlight"
    vim.cmd("highlight YankHighlight guibg=#e0af68")

    -- Create an autocommand group called "YankHighlight" and clear it
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

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()
