local utils = require("utils")

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
    config = function()
        local function setup_incline()
            require("incline").setup({
                window = {
                    padding = 0,
                },
                hide = {
                    cursorline = false,
                },
                render = function(props)
                    local fullpath = vim.api.nvim_buf_get_name(props.buf)
                    local filename = vim.fn.fnamemodify(fullpath, ":t")
                    if filename == "" then
                        filename = "[No Name]"
                    end

                    local function get_ft_icon()
                        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
                        return { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" }
                    end

                    local function get_file_path()
                        local path_display = ""
                        if fullpath == "" then
                            path_display = filename
                        else
                            local parts = {}
                            for part in string.gmatch(vim.fn.fnamemodify(fullpath, ":.:h"), "[^/]+") do
                                table.insert(parts, part)
                            end

                            local ellipsis = "…"
                            local max_path_parts = 2
                            if #parts > max_path_parts then
                                local start_index = #parts - max_path_parts + 1
                                path_display = ellipsis .. "/" .. table.concat(parts, "/", start_index)
                            elseif #parts > 0 then
                                path_display = table.concat(parts, "/")
                            end

                            if path_display ~= "" then
                                path_display = path_display .. "/" .. filename
                            else
                                path_display = filename
                            end
                        end

                        return { path_display .. " ┊", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" }
                    end

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
                        guibg = utils.ayu_colors.panel_bg,
                        guifg = utils.ayu_colors.fg,
                        { " " },
                        { get_diagnostic_label() },
                        { get_git_diff() },
                        { get_ft_icon() },
                        { get_file_path() },
                        { get_arrow_label() .. "  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
                        { " " }
                    }
                end,
            })
        end

        utils.create_user_event_cb("ColorsyncThemeChanged", setup_incline, "ColorsyncEvents")
        setup_incline()
    end
}
