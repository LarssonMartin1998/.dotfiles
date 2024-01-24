
local function setup_yank_highlight()
    -- Create a new highlight group which will be used for yank highlighting with the name "YankHighlight"
    vim.cmd("highlight YankHighlight guibg=#e0af68")

    -- Create an autocommand group called "YankHighlight" and clear it
    local yank_autocommand = vim.api.nvim_create_augroup("YankHighlightAutocommand", { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                timeout = 250,
                higroup = "YankHighlight",
            })
        end,
        group = yank_autocommand,
        pattern = "*",
    })
end

-- Load keymaps before loading any plugins
require("keymaps")

 -- change and personalize native vim settings
vim.opt = require("vim_opt")

 -- Initialize Lazy package manager
require("lazy_init")

 -- Initialize plugins, add a plugin by creating a new file in the plugins dir
require("lazy").setup("plugs")

-- See ":help vim.highlight.on_yank()"
setup_yank_highlight()


-- Save this code snippet for later, it is used to automatically run cmake when saving a file in a project, this way we can have an up to date compile_commands.json file for clangd.
-- TODO: Make sure to only run this when clangd is being used as the language server. Additionally, find a way to make this work on projects with multiple CMakeLists.txt files, or that arent using CMake at all.
-- -- Define a function to find the main.cpp and CMakeLists.txt files using fzf
-- function FindMainAndCMakeLists()
--     local main_cpp = vim.fn.systemlist('fzf --preview "bat {}" --query main.cpp --select-1')[1]
--     local cmake_lists = vim.fn.systemlist('fzf --preview "bat {}" --query CMakeLists.txt --select-1')[1]
--     return main_cpp, cmake_lists
-- end
--
-- -- Function to update the autocmd based on the found main.cpp and CMakeLists.txt files
-- function UpdateAutocmd(main_cpp_path, cmake_lists_path)
--     if main_cpp_path ~= '' and cmake_lists_path ~= '' then
--         local main_cpp_directory = vim.fn.fnamemodify(main_cpp_path, ':h')
--         vim.api.nvim_exec(string.format([[
--             autocmd! BufWritePost %s/**/* :call system('cmake %s')
--         ]], main_cpp_directory, cmake_lists_path), false)
--     else
--         print("main.cpp or CMakeLists.txt not found. Autocmd not updated.")
--     end
-- end
--
-- -- Automatically find main.cpp and CMakeLists.txt and set up the initial autocmd
-- local main_cpp_path, cmake_lists_path = FindMainAndCMakeLists()
-- UpdateAutocmd(main_cpp_path, cmake_lists_path)
