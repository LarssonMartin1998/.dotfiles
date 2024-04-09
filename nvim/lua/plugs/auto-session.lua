return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup {
            log_level = "error",
            auto_session_suppress_dirs = {
                "/",
                "~/",
                "~/Projects",
                "~/Downloads",
                "~/Development",
                "~/Dev",
                "~/Dev/Git",
                "~/.config",
                "~/dev/git/.dotfiles",
            },
        }
    end
}
