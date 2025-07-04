local opt = vim.opt

-- Disable tabs, will use telescope and harpoon instead
opt.showtabline = 0

-- Make Vim use the system clipboard
opt.clipboard = "unnamedplus"

-- Highlight the currently selected row
opt.cursorline = true
opt.cursorlineopt = "number"

-- Indenting
opt.expandtab = true
opt.cindent = true
-- opt.smartindent = true
opt.breakindent = true
opt.breakindentopt = "list:-1"
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Disable home screen
opt.shortmess:append("sI")

-- Signcolumn
opt.signcolumn = "yes:2"      -- Adds a spacing to the left which can contain gutter icons
opt.fillchars = { eob = " " } -- Remove the fill character for empty lines which defaults to: "~"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Command
opt.inccommand = "nosplit"

-- Disable mouse support
opt.mouse = ""

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Disable swapfile, 99/100 times it just gets in the way
opt.swapfile = false

-- Buffers
opt.splitright = true
opt.splitbelow = true

-- Removes the extra command line bar at the bottom, using lualine instead
opt.cmdheight = 0

-- Statusline
opt.laststatus = 3

-- Terminal integration
opt.termguicolors = true
opt.termsync = true

-- Sets a minimum number of lines to keep above and below the cursor
opt.scrolloff = 4

-- Whitespaces
opt.list = false

-- Sessions
opt.sessionoptions = { "buffers", "curdir", "winsize", "winpos", "skiprtp" }

-- Builtin LSP completion tweaks
-- See comment in lspsetup autocmd for LspAttach
-- opt.completeopt = "menu,menuone,noselect,fuzzy"

opt.fileignorecase = true

-- This makes window sizing more controllable, with this set to true theyre always the same size.
opt.equalalways = false

opt.linebreak = true
opt.ruler = false
opt.shiftround = true

-- Faster draw
opt.redrawtime = 150

-- Disable lots of unnecessary warning notifications
opt.shortmess = "acstFOSW"

-- Allows to select one more after EOL
opt.virtualedit = "onemore"

opt.winborder = "single"

opt.wrap = false
opt.sidescroll = 4
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "markdown", "txt", "md", "codecompanion" },
    callback = function()
        vim.opt_local.wrap = true
    end
})

return opt
