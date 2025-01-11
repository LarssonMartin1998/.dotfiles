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
require("lsp")

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()
