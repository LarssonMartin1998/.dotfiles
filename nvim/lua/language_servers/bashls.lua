local utils = require("lspconfig.util")

return {
    default_config = {
        cmd = { "bash-language-server", "start" },
        settings = {
            bashIde = {
                -- Glob pattern for finding and parsing shell script files in the workspace.
                -- Used by the background analysis features across files.

                -- Prevent recursive scanning which will cause issues when opening a file
                -- directly in the home directory (e.g. ~/foo.sh).
                --
                -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
                globPattern = vim.env.GLOB_PATTERN or "**/*@(.sh|.inc|.bash|.command|.zsh|zshrc|zsh_*)",
            },
            bash = {
                format = {
                    enable = true,
                    shell = "shfmt",
                    args = {
                        "-i",
                        "4",
                        "-bn",
                        "-ci"
                    }
                },
                ignorePatterns = {
                    "node_modules",
                    ".git"
                },
                lint = {
                    enable = true
                },
                trace = {
                    server = "verbose"
                },
            },
        },
        filetypes = { "sh", "zsh" },
        root_dir = utils.find_git_ancestor,
        single_file_support = true,
    },
}
