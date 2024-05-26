local utils = require("utils")

local function lock_oil_buf_to_window(win_id, bufnr)
    local augroup_id = vim.api.nvim_create_augroup("LockWindowToBuffer" .. win_id, { clear = true })

    -- Create an autocommand group to manage the buffer lock
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup_id,
        callback = function()
            local current_win = vim.api.nvim_get_current_win()
            if current_win ~= win_id then
                return
            end

            local current_buf = vim.api.nvim_win_get_buf(win_id)
            if current_buf == bufnr then
                return
            end

            if utils.is_buf_filetype(current_buf, "oil") then
                bufnr = current_buf
                return
            end

            vim.api.nvim_win_set_buf(win_id, bufnr)
        end,
    })
end

return {
    "stevearc/oil.nvim",
    config = function()
        local oil = require("oil")
        oil.setup({
            view_options = {
                show_hidden = true,
            },
            win_options = {
                wrap = true,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
        })

        require("utils").add_keymaps({
            n = {
                ["<leader>o"] = {
                    cmd = function()
                        local oil_bufnr = utils.get_bufnr_for_filetype("oil")
                        if oil_bufnr then
                            vim.api.nvim_buf_delete(oil_bufnr, { force = true })
                            return
                        end

                        -- Calculate the desired width (e.g., 20% of the terminal width)
                        local term_width = vim.api.nvim_get_option("columns")
                        local width_percentage = 0.175
                        local min_width = 30
                        local max_width = 50
                        local calculated_width = math.floor(term_width * width_percentage)
                        local final_width = math.min(math.max(calculated_width, min_width), max_width)

                        -- Open a vertical split with the calculated width on the left and open oil.nvim
                        vim.cmd("topleft vertical " .. final_width .. "vnew")
                        local win_id = vim.api.nvim_get_current_win()
                        vim.api.nvim_win_set_option(win_id, "winfixwidth", true)

                        vim.api.nvim_win_set_option(win_id, "winhighlight",
                            "Normal:Utility,FloatBorder:Utility")

                        oil.open()
                        local oil_buf_id = vim.api.nvim_get_current_buf()
                        lock_oil_buf_to_window(win_id, oil_buf_id)
                    end
                }
            }
        })
    end,
}
