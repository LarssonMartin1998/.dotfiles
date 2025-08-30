return {
    "dmtrKovalenko/fff.nvim",
    build = "nix run .#release",
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
}
