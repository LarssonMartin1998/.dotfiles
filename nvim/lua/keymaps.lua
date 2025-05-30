local utils = require("utils")
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

local move_up = { "v:count || mode(1)[0:1] == \"no\" ? \"k\" : \"gk\"", { expr = true } }
local move_down = { "v:count || mode(1)[0:1] == \"no\" ? \"j\" : \"gj\"", { expr = true } }

utils.foreach({
    {
        "n",
        {
            { "K",         "<Nop>", },
            { "grn",       "<Nop>", },
            { "gra",       "<Nop>", },
            { "grr",       "<Nop>", },
            { "gri",       "<Nop>", },
            { "gO",        "<Nop>", },
            -- Navigation
            { "<C-Left>",  "<C-w>h", },
            { "<C-Down>",  "<C-w>j", },
            { "<C-Up>",    "<C-w>k", },
            { "<C-Right>", "<C-w>l", },
            { "<C-h>",     "<C-w>h", },
            { "<C-j>",     "<C-w>j", },
            { "<C-k>",     "<C-w>k", },
            { "<C-l>",     "<C-w>l", },

            -- Window
            { "<C-q>",     "<C-w>q", },

            -- Disable current highlights
            { "<Esc>",     "<cmd> noh <CR>", },

            -- Copies the entire file
            { "<C-c>",     ":%y+<CR>",       { silent = true } },

            -- Allow moving the cursor through wrapped lines with <Up> and <Down>
            -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
            -- empty mode is same as using <cmd> :map
            -- also don't use g[j|k] when in operator pending mode,
            -- so it doesn't alter d, y or c behaviour
            { "<Up>",      move_up[1],       move_up[2], },
            { "<Down>",    move_down[1],     move_down[2], },
            { "j",         move_down[1],     move_down[2], },
            { "k",         move_up[1],       move_up[2], },
            -- Maps to remove
            { "<C-z>",     "<Nop>", },

            -- Marks are less frequently used than leaping, also, less relevant with arrow and fzf navigation.
            -- Prioritize regular m for leaping, and <leader>m for setting marks.
            { "<leader>m", "m", },
            { "[d", function()
                vim.diagnostic.jump({ count = -1, float = false })
            end },
            { "]d", function()
                vim.diagnostic.jump({ count = 1, float = false })
            end },
        }
    },
    {
        "v",
        {
            { "<Up>",      move_up[1],   move_up[2], },
            { "<Down>",    move_down[1], move_down[2], },
            { "j",         move_down[1], move_down[2], },
            { "k",         move_up[1],   move_up[2], },
            { "<tab>",     ">gv", },
            { "<S-tab>",   "<gv", },

            -- Marks are less frequently used than leaping, also, less relevant with arrow and fzf navigation.
            -- Prioritize regular m for leaping, and <leader>m for setting marks.
            { "<leader>m", "m", },
        },
    },
    {
        "x",
        {
            { "<Up>",   move_up[1],                       move_up[2], },
            { "<Down>", move_down[1],                     move_down[2], },
            { "j",      move_down[1],                     move_down[2], },
            { "k",      move_up[1],                       move_up[2], },
            { "p",      "p:let @+=@0<CR>:let @\"=@0<CR>", { silent = true }, },
        }
    },
    {
        "t",
        {
            { "<C-q>", "<C-\\><C-N>", },
        }
    },
}, function(mode_mapping)
    local mode = mode_mapping[1]
    local mappings = mode_mapping[2]
    utils.set_keymap_list(mappings, mode)
end)
