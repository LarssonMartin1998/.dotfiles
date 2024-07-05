local wm = require("window_management")

local is_trouble_window = false

local function setup_autosize_callback()
    local auname = "TroubleWinEnter"
    local augroup = vim.api.nvim_create_augroup(auname, { clear = true })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function()
            if not is_trouble_window then
                return
            end

            is_trouble_window = false
            wm.autosize_windows()
        end,
    })
end

return {
    "folke/trouble.nvim",
    config = function()
        local trouble = require("trouble")
        trouble.setup({})

        setup_autosize_callback()
        require("utils").add_keymaps({
            n = {
                ["<leader>x"] = {
                    cmd = function()
                        is_trouble_window = true
                        trouble.toggle({
                            mode = "diagnostics",
                            focus = true,
                        })
                    end
                },
                ["<leader>ls"] = {
                    cmd = function()
                        is_trouble_window = true
                        trouble.toggle({
                            mode = "symbols",
                            focus = true,
                        })
                    end
                },
                ["<leader>ll"] = {
                    cmd = function()
                        is_trouble_window = true
                        trouble.toggle({
                            mode = "loclist",
                            focus = true,
                        })
                    end
                },
                ["<leader>lq"] = {
                    cmd = function()
                        is_trouble_window = true
                        trouble.toggle({
                            mode = "quickfix",
                            focus = true,
                        })
                    end
                },
            }
        })
    end
}
