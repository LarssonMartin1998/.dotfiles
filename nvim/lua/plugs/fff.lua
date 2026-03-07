return {
    "dmtrKovalenko/fff.nvim",
    build = "nix run .#release",
    lazy = false,
    keys = {
        {
            "<leader>f",
            function() require("fff").find_files() end,
            desc = "FFFind files",
        }
    }
}
