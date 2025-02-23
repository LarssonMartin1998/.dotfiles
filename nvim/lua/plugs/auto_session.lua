return {
    "rmagatti/auto-session",
    opts = {
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
        },
    },
    init = function()
        vim.o.sessionoptions = "localoptions"
    end
}
