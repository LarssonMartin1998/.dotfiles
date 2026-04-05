local function setup_incline()
    require("incline").setup({
        window = {
            padding = 0,
        },
        hide = {
            cursorline = true,
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
                local summary = vim.b[props.buf].minidiff_summary
                local labels = {}
                if summary == nil then
                    return labels
                end
                for name, icon in pairs({ Delete = "-", Change = "~", Add = "+" }) do
                    if tonumber(summary[name:lower()]) and summary[name:lower()] > 0 then
                        table.insert(labels, { icon .. " " .. summary[name:lower()] .. " ", group = "MiniDiffSign" .. name })
                    end
                end
                if #labels > 0 then
                    table.insert(labels, { "┊ " })
                end
                return labels
            end

            local function get_diagnostic_label()
                local sev = vim.diagnostic.severity
                local label = {}
                for _, entry in ipairs({
                    { sev.ERROR, "Error", "DiagnosticError" },
                    { sev.WARN,  "Warn",  "DiagnosticWarn" },
                    { sev.INFO,  "Info",  "DiagnosticInfo" },
                    { sev.HINT,  "Hint",  "DiagnosticHint" },
                }) do
                    local severity, kind, group = entry[1], entry[2], entry[3]
                    local n = #vim.diagnostic.get(props.buf, { severity = severity })
                    if n > 0 then
                        local icon = MiniIcons.get("lsp", kind)
                        table.insert(label, { icon .. " " .. n .. " ", group = group })
                    end
                end
                if #label > 0 then
                    table.insert(label, { "┊ " })
                end
                return label
            end

            return {
                { " " },
                { get_diagnostic_label() },
                { get_git_diff() },
                { get_ft_icon() },
                { get_file_path() },
                { " " }
            }
        end,
    })
end

vim.api.nvim_create_autocmd("User",
    { pattern = "ColorsyncThemeChanged", callback = setup_incline, group = "ColorsyncEvents" })
setup_incline()
