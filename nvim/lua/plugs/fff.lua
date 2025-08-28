return {
    "dmtrKovalenko/fff.nvim",
    build = "nix run .#release",
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
        {
            "ff", -- try it if you didn't it is a banger keybinding for a picker
            function() require('fff').find_files() end,
            desc = 'FFFind files',
        }
    }
}
