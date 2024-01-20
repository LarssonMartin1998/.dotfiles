 -- Load keymaps before loading any plugins
require("keymaps")

 -- change and personalize native vim settings
vim.opt = require("vim_opt")

 -- Initialize Lazy package manager
require("lazy_init")

 -- Initialize plugins, add a plugin by creating a new file in the plugins dir
require("lazy").setup("plugs")
