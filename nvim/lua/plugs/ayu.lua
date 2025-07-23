local uv = vim.loop
local api = vim.api

local function force_color_from_reference_on_others(others, reference)
    local reference_hl = vim.api.nvim_get_hl(0, { name = reference })
    for _, member in ipairs(others) do
        local property = vim.api.nvim_get_hl(0, { name = member })
        property.fg = reference_hl.fg
        vim.api.nvim_set_hl(0, member, property)
    end
end

local function reset_hl_groups_for_ft(groups_to_reset)
    for _, group in ipairs(groups_to_reset) do
        local ft = group[1]
        local groups = group[2]

        vim.api.nvim_create_autocmd("FileType", {
            pattern = ft,
            callback = function()
                for _, group_name in ipairs(groups) do
                    vim.api.nvim_set_hl(0, group_name, {})
                end
            end,
        })
    end
end

return {
    "Shatur/neovim-ayu",
    config = function()
        local ayu = require("ayu")
        local colors = require("ayu.colors")
        colors.generate(true)

        local overrides = {
            global_variable = {
                underline = true,
                italic = true,
            },
            member_variable = {
                bold = true,
            },
            namespace = {
                italic = true,
                fg = colors.markup,
            },
            pre_process = {
                fg = colors.keyword,
            },
            default_type = {
                fg = colors.regexp
            },
            type = {
                fg = colors.entity,
            },
        }

        ayu.setup({
            mirage = true,
            terminal = false,
            overrides = {
                -- TRANSPARENCY
                -- Normal = { bg = "none" },
                -- NormalFloat = { bg = "none" },
                -- ColorColumn = { bg = "none" },
                -- SignColumn = { bg = "none" },
                -- Folded = { bg = "none" },
                -- FoldColumn = { bg = "none" },
                -- CursorColumn = { bg = "none" },
                -- VertSplit = { bg = "none" },
                -- TRANSPARENCY
                CursorLineNr = { bg = "none" },
                ["@property"] = overrides.member_variable,
                ["PreProc"] = overrides.pre_process,
                --CPP
                ["@lsp.typemod.variable.fileScope.cpp"] = overrides.global_variable,
                ["@lsp.type.namespace.cpp"] = overrides.namespace,
                ["@type.builtin.cpp"] = overrides.default_type,
                -- CPP
                --
                -- Rust
                ["@lsp.type.struct.rust"] = overrides.type,
                ["@lsp.type.namespace.rust"] = overrides.namespace,
                ["@lsp.type.builtinType.rust"] = overrides.default_type,
                -- Rust
                --
                -- C
                ["@lsp.typemod.variable.globalScope.c"] = overrides.global_variable,
                ["@type.builtin.c"] = overrides.default_type,
                -- C
                --
                -- Go
                -- ["@module.go"] = overrides.namespace, -- The go LSP is not reliable enough for this sadly, sometimes it adds module tokens and sometimes it doesnt.
                ["@variable.member.go"] = overrides.member_variable,
                ["@type.builtin.go"] = overrides.default_type,
                -- Go
                --
                -- Zig
                ["@module.zig"] = overrides.namespace,
                ["@type.builtin.zig"] = overrides.default_type,
                ["@function.builtin.zig"] = overrides.default_type,
                -- ["@variable.member.zig"] = overrides.member_variable,-- Cant have bold member variable in zig, they don't differentiate function calls/accessors from variables, they are all just "members" .... BS LSP
                -- ["@variable.parameter"] = {},-- Zig LSP is lacking, a parameter is marked as a regular variable outside of it's definition, can't separate between them.
                -- Zig
            },
        })

        local function set_colorscheme()
            local active_theme = vim.fn.system({ "colorsync", "get" }):gsub("%s+", "")
            if active_theme == "ayulight" then
                api.nvim_command("colorscheme ayu-light")
            elseif active_theme == "ayumirage" then
                api.nvim_command("colorscheme ayu-mirage")
            else
                api.nvim_command("colorscheme ayu-dark")
            end
        end

        local filepath = os.getenv("HOME") .. "/.local/state/colorsync/current"
        local handle = uv.new_fs_event()
        handle:start(filepath, {}, function(err, filename, status)
            if err then
                vim.notify("Error watching: " .. filepath .. "\n" .. err)
                return
            end

            vim.schedule(set_colorscheme)
        end)

        set_colorscheme()

        -- Fix nuances of the colorscheme in different languages.
        -- These changes needs to run after the colorscheme is set.
        force_color_from_reference_on_others({
            "@property",
            "@variable.member.go",
            "@variable.member",
            "@variable.member.zig",
        }, "@variable")

        reset_hl_groups_for_ft({
            { "go", { "@property", } },
        })
    end
}
