vim.opt.runtimepath:append("/Users/larssonmartin/dev/git/nvim-rephrase")
if pcall(require, "rephrase") then
    require("rephrase").setup({})
end
