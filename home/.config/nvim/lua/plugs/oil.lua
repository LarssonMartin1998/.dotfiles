local function get_oil_bufnr()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "oil" then
            return buf
        end
    end

    return nil
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
                        local oil_bufnr = get_oil_bufnr()
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
                        oil.open()
                    end
                }
            }
        })
    end,
}
