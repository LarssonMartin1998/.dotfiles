-- return
-- {
--     "dmtrKovalenko/fff.nvim",
--     build = "nix run .#release",
--     -- No need to lazy-load with lazy.nvim.
--     -- This plugin initializes itself lazily.
--     lazy = false,
-- }
return {
    "dmtrKovalenko/fff.nvim",
    build = "nix run .#release",
    -- opts = {
    -- debug = {
    --   enabled = true,     -- we expect your collaboration at least during the beta
    --   show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    -- },
    -- },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
        {
            "<leader>f", -- try it if you didn't it is a banger keybinding for a picker
            function() require("fff").find_files() end,
            desc = "FFFind files",
        }
    }
}
