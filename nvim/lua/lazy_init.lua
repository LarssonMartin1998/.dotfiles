local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize plugins, add a plugin by creating a new file in the plugins dir
require("lazy").setup("plugs", {
    git = {
        timeout = 300
    },
    dev = {
        path = "~/dev/git/",
        fallback = true,
    },
})
