local M = {}

local STAGED_STATUSES = {
    staged_new = true,
    staged_modified = true,
    staged_deleted = true,
    renamed = true,
}

local STATUS_MAP = {
    untracked = "untracked",
    modified = "modified",
    deleted = "deleted",
    renamed = "renamed",
    staged_new = "added",
    staged_modified = "modified",
    staged_deleted = "deleted",
    ignored = "ignored",
    unknown = "untracked",
}

local STATUS_ICONS = {
    untracked = "?",
    ignored = "!",
}

---@class FFFState
---@field current_file_cache? string
---@field file_picker? table
M.state = {}

---Get the current file path if valid
---@return string|nil
local function get_current_file()
    local current_buf = vim.api.nvim_get_current_buf()
    if not (current_buf and vim.api.nvim_buf_is_valid(current_buf)) then
        return nil
    end

    local current_file = vim.api.nvim_buf_get_name(current_buf)
    return (current_file ~= "" and vim.fn.filereadable(current_file) == 1) and current_file or nil
end

---Create git status object
---@param git_status string
---@return table|nil
local function create_git_status(git_status)
    local mapped_status = STATUS_MAP[git_status]
    if not mapped_status then
        return nil
    end

    return {
        status = mapped_status,
        staged = STAGED_STATUSES[git_status] or false,
        unmerged = git_status == "unmerged",
    }
end

---Get or initialize file picker
---@return table|nil
local function get_file_picker()
    if M.state.file_picker then
        return M.state.file_picker
    end

    local ok, file_picker = pcall(require, "fff.file_picker")
    if not ok then
        vim.notify("Failed to load fff.file_picker: " .. file_picker, vim.log.levels.ERROR)
        return nil
    end

    M.state.file_picker = file_picker
    return file_picker
end

---Format git status highlight group name
---@param status table
---@return string
local function get_status_highlight(status)
    if status.unmerged then
        return "SnacksPickerGitStatusUnmerged"
    elseif status.staged then
        return "SnacksPickerGitStatusStaged"
    else
        local status_name = status.status
        return "SnacksPickerGitStatus" .. status_name:sub(1, 1):upper() .. status_name:sub(2)
    end
end

---Get status icon text
---@param status_name string
---@return string
local function get_status_icon(status_name)
    return STATUS_ICONS[status_name] or status_name:sub(1, 1):upper()
end

local function finder(_, ctx)
    local file_picker = get_file_picker()
    if not file_picker then
        return {}
    end

    -- Cache current file only once per session
    if not M.state.current_file_cache then
        M.state.current_file_cache = get_current_file()
    end

    local ok, fff_result = pcall(
        file_picker.search_files,
        ctx.filter.search,
        100,
        4,
        M.state.current_file_cache,
        false
    )

    if not ok then
        vim.notify("FFF search failed: " .. fff_result, vim.log.levels.ERROR)
        return {}
    end

    local items = {}
    for _, fff_item in ipairs(fff_result) do
        local item = {
            text = fff_item.name,
            file = fff_item.path,
            score = fff_item.total_frecency_score,
            status = create_git_status(fff_item.git_status),
        }
        table.insert(items, item)
    end

    return items
end

local function on_close()
    M.state.current_file_cache = nil
end

local function format_file_git_status(item, _)
    local status = item.status
    local hl = get_status_highlight(status)
    local icon = get_status_icon(status.status)

    return {
        {
            col = 0,
            virt_text = { { icon, hl }, { " " } },
            virt_text_pos = "right_align",
            hl_mode = "combine",
        }
    }
end

local function format(item, picker)
    local ret = {}

    if item.label then
        vim.list_extend(ret, {
            { item.label, "SnacksPickerLabel" },
            { " ",        virtual = true }
        })
    end

    if item.status then
        vim.list_extend(ret, format_file_git_status(item, picker))
    end

    vim.list_extend(ret, require("snacks.picker.format").filename(item, picker))

    if item.line then
        Snacks.picker.highlight.format(item, item.line, ret)
        table.insert(ret, { " " })
    end

    return ret
end

function M.fff()
    local file_picker = get_file_picker()
    if not file_picker then
        return
    end

    if not file_picker.is_initialized() then
        local setup_success = file_picker.setup()
        if not setup_success then
            vim.notify("Failed to initialize file picker", vim.log.levels.ERROR)
            return
        end
    end

    Snacks.picker {
        title = "FFFiles",
        finder = finder,
        on_close = on_close,
        format = format,
        live = true,
    }
end

return M
