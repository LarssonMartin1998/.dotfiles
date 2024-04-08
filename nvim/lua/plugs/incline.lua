return {
    "b0o/incline.nvim",
    dependencies = {
        "lewis6991/gitsigns.nvim"
    },
    config = function()
        require("gitsigns").setup({})
        local devicons = require("nvim-web-devicons")
        require("incline").setup({
            window = {
                padding = 0,
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                if filename == "" then
                    filename = "[No Name]"
                end
                local ft_icon, ft_color = devicons.get_icon_color(filename)

                local function get_git_diff()
                    local icons = { removed = "", changed = "", added = "" }
                    local signs = vim.b[props.buf].gitsigns_status_dict
                    local labels = {}
                    if signs == nil then
                        return labels
                    end
                    for name, icon in pairs(icons) do
                        if tonumber(signs[name]) and signs[name] > 0 then
                            table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
                        end
                    end
                    if #labels > 0 then
                        table.insert(labels, { "┊ " })
                    end
                    return labels
                end

                local function get_diagnostic_label()
                    local icons = { error = "", warn = "", info = "", hint = "" }
                    local label = {}

                    for severity, icon in pairs(icons) do
                        local n = #vim.diagnostic.get(props.buf,
                            { severity = vim.diagnostic.severity[string.upper(severity)] })
                        if n > 0 then
                            table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
                        end
                    end
                    if #label > 0 then
                        table.insert(label, { "┊ " })
                    end
                    return label
                end

                -- TODO: Make this fetch data from arrow using the file that the statusline is running on.
                -- This will require a pull request to change how it handles the statusline.
                -- Right now it just uses the current buffer.
                -- It can still be the same UX but with the option of sending in a path to work on.
                local function get_arrow_label()
                    local statusline = require("arrow.statusline")
                    if statusline.is_on_arrow_file() == nil then
                        return ""
                    end

                    return " " .. statusline.text_for_statusline_with_icons()
                end

                return {
                    guibg = "#1e2030",
                    guifg = "#cad3f5",
                    { " " },
                    { get_diagnostic_label() },
                    { get_git_diff() },
                    { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
                    { filename .. " ┊", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
                    { get_arrow_label() .. "  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
                    { " " }
                }
            end,
        })
    end,
    event = "VeryLazy",
}
