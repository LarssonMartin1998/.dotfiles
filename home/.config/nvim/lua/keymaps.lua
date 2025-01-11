local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

local move_up = {
    cmd = "v:count || mode(1)[0:1] == \"no\" ? \"k\" : \"gk\"",
    opts = {
        expr = true
    }
}

local move_down = {
    cmd = "v:count || mode(1)[0:1] == \"no\" ? \"j\" : \"gj\"",
    opts = {
        expr = true
    }
}

require("utils").add_keymaps({
    n = {
        -- Navigation
        ["<C-Left>"] = {
            cmd = "<C-w>h",
        },
        ["<C-Down>"] = {
            cmd = "<C-w>j",
        },
        ["<C-Up>"] = {
            cmd = "<C-w>k",
        },
        ["<C-Right>"] = {
            cmd = "<C-w>l",
        },
        ["<C-h>"] = {
            cmd = "<C-w>h",
        },
        ["<C-j>"] = {
            cmd = "<C-w>j",
        },
        ["<C-k>"] = {
            cmd = "<C-w>k",
        },
        ["<C-l>"] = {
            cmd = "<C-w>l",
        },

        -- Window
        ["<C-q>"] = {
            cmd = "<C-w>q",
        },

        -- Disable current highlights
        ["<Esc>"] = {
            cmd = "<cmd> noh <CR>",
        },

        -- Copies the entire file
        ["<C-c>"] = {
            cmd = ":%y+<CR>",
            opts = {
                silent = true
            }
        },

        -- Allow moving the cursor through wrapped lines with <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        ["<Up>"] = move_up,
        ["<Down>"] = move_down,
        ["j"] = move_down,
        ["k"] = move_up,
        -- Maps to remove
        ["<C-z>"] = {
            cmd = "<Nop>",
        },

        -- Marks are less frequently used than leaping, also, less relevant with arrow and fzf navigation.
        -- Prioritize regular m for leaping, and <leader>m for setting marks.
        ["<leader>m"] = {
            cmd = "m",
        },
    },
    i = {},
    v = {
        ["<Up>"] = move_up,
        ["<Down>"] = move_down,
        ["j"] = move_down,
        ["k"] = move_up,
        ["<tab>"] = {
            cmd = ">gv",
        },
        ["<S-tab>"] = {
            cmd = "<gv",
        },

        -- Marks are less frequently used than leaping, also, less relevant with arrow and fzf navigation.
        -- Prioritize regular m for leaping, and <leader>m for setting marks.
        ["<leader>m"] = {
            cmd = "m",
        },
    },
    x = {
        ["<Up>"] = move_up,
        ["<Down>"] = move_down,
        ["j"] = move_down,
        ["k"] = move_up,
        ["p"] = {
            cmd = "p:let @+=@0<CR>:let @\"=@0<CR>",
            opts = {
                silent = true
            },
        },
    },
    t = {
        ["<C-q>"] = {
            cmd = "<C-\\><C-N>",
        },
    },
})
