local opt = vim.opt

 -- Disable tabs, will use telescope and harpoon instead
opt.showtabline = 0

 -- Make Vim use the system clipboard
opt.clipboard = "unnamedplus"

 -- Highlight the currently selected row
opt.cursorline = true
opt.cursorlineopt = "both"

 -- Indenting
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

 -- Disable home screen
opt.shortmess:append("sI")

 -- Signcolumn
opt.signcolumn = "yes:1" -- Adds a spacing to the left which can contain gutter icons
opt.fillchars = { eob = " " } -- Remove the fill character for empty lines which defaults to: "~"

 -- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

 -- Disable mouse support
opt.mouse = ""

 -- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

 -- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

 -- Richer colors in terminal, not all terminals support this
opt.termguicolors = true

 -- Disable swapfile, 99/100 times it just gets in the way
opt.swapfile = false

 -- Buffers
opt.splitright = true
opt.splitbelow = true

 -- Removes the extra command line bar at the bottom, using lualine instead
opt.cmdheight = 0

return opt
