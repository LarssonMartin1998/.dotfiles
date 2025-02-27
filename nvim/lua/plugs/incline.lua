return {
    "b0o/incline.nvim",
    dependencies = {
        {
            "lewis6991/gitsigns.nvim",
            opts = {},
            keys = {
                { "[g", function() require("gitsigns").nav_hunk("prev") end, },
                { "]g", function() require("gitsigns").nav_hunk("next") end, },
            }
        }
    },
    event = "VeryLazy",
    lazy = true,
    opts = {
        window = {
            padding = 0,
        },
        hide = {
            cursorline = true,
        },
        render = function(props)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            if filename == "" then
                filename = "[No Name]"
            end
            local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)

            local function get_git_diff()
                local icons = { removed = "", changed = "", added = "" }
                local signs = vim.b[props.buf].gitsigns_status_dict
                local labels = {}
                if signs == nil then
                    return labels
                end
                for name, icon in pairs(icons) do
                    if tonumber(signs[name]) and signs[name] > 0 then
                        table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
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
                        table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
                    end
                end
                if #label > 0 then
                    table.insert(label, { "┊ " })
                end
                return label
            end

            local function get_arrow_label()
                local statusline = require("arrow.statusline")
                if statusline.is_on_arrow_file(props.buf) == nil then
                    return ""
                end

                return " " .. statusline.text_for_statusline_with_icons(props.buf)
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
    },
}
