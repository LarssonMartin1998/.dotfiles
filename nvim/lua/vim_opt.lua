local opt = vim.opt
local opt_local = vim.opt_local
local api = vim.api

-- Disable tabs
opt.showtabline = 0

-- Make Vim use the system clipboard
opt.clipboard = "unnamedplus"

-- Highlight the currently selected row
opt.cursorline = true
opt.cursorlineopt = "line"

opt.breakindent = true
opt.breakindentopt = "list:-1"

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
opt.updatetime = 400
opt.timeoutlen = 750

-- Disable swapfile, 99/100 times it just gets in the way
opt.swapfile = false

-- Buffers
opt.splitright = true
opt.splitbelow = true

-- Hide the cmdline bar when not in use; UI2 shows a float when needed
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
opt.sessionoptions = { "buffers", "curdir", "winsize", "winpos", "tabpages", "skiprtp" }

opt.fileignorecase = true

-- This makes window sizing more controllable, with this set to true theyre always the same size.
opt.equalalways = false

opt.linebreak = true
opt.ruler = false
opt.shiftround = true

-- Faster draw
opt.redrawtime = 150

-- Disable lots of unnecessary warning notifications
opt.shortmess = "acstFOSWI"

-- Allows to select one more after EOL
opt.virtualedit = "onemore"

opt.winborder = "single"

opt.wrap = false
opt.sidescroll = 4

opt.expandtab = true
opt.cindent = false
opt.smartindent = true
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

local indent_group = api.nvim_create_augroup("IndentConfig", { clear = true })
for _, group in ipairs({
    {
        { "text", "markdown", "codecompanion", "gitcommit", },
        function()
            opt_local.wrap = true
            opt_local.cindent = false
            opt_local.smartindent = false
            opt_local.autoindent = false
        end,
    },
    {
        { "cpp", "c", },
        function()
            opt_local.expandtab = true
            opt_local.cindent = true
            opt_local.smartindent = false
            opt_local.autoindent = false
            opt_local.shiftwidth = 4
            opt_local.tabstop = 4
            opt_local.softtabstop = 4
        end,
    },
    {
        { "rust", "zig", "python", "cs", "go", "lua", },
        function()
            opt_local.expandtab = true
            opt_local.cindent = false
            opt_local.smartindent = true
            opt_local.autoindent = true
            opt_local.shiftwidth = 4
            opt_local.tabstop = 4
            opt_local.softtabstop = 4
        end,
    },
    {
        { "typescript", "javascript", "typescriptreact", "javascriptreact", "ruby", "json", "nix", },
        function()
            opt_local.expandtab = true
            opt_local.cindent = false
            opt_local.smartindent = true
            opt_local.autoindent = true
            opt_local.shiftwidth = 2
            opt_local.tabstop = 2
            opt_local.softtabstop = 2
        end,
    },
}) do
    api.nvim_create_autocmd("FileType", {
        pattern = group[1],
        callback = group[2],
        group = indent_group,
        desc = "Local settings for indentation per filetype",
    })
end

return opt
