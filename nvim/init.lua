vim.loader.enable() -- cache for faster startups
require('vim._core.ui2').enable({})

require("colorsync_integration")
require("keymaps")
require("vim_opt")
require("terminal")
require("window_management").setup()
require("lspsetup")
require("diagnostics")
