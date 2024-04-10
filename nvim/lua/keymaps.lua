local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

require("utils").add_keymaps({
    n = {
        -- Disable hjkl, using Colemak
        ["h"] = {
            cmd = "<Nop>",
        },
        ["j"] = {
            cmd = "<Nop>",
        },
        ["k"] = {
            cmd = "<Nop>",
        },
        ["l"] = {
            cmd = "<Nop>",
        },
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

        -- Disable current highlights
        ["<Esc>"] = {
            cmd = "<cmd> noh <CR>",
        },

        -- Save
        ["<C-s>"] = {
            cmd = "<cmd> w <CR>",
        },

        -- Copies the entire file
        ["<C-c>"] = {
            cmd = "ggyG <C-o><C-o>",
        },

        -- Allow moving the cursor through wrapped lines with <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        ["<Up>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"k\" : \"gk\"",
            opts = {
                expr = true
            }
        },
        ["<Down>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"j\" : \"gj\"",
            opts = {
                expr = true
            }
        },
        -- Maps to remove
        ["<C-z>"] = {
            cmd = "<Nop>",
        },
    },
    i = {},
    v = {
        ["<Up>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"k\" : \"gk\"",
            opts = {
                expr = true
            }
        },
        ["<Down>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"j\" : \"gj\"",
            opts = {
                expr = true
            }
        },
        ["<tab>"] = {
            cmd = ">gv",
        },
        ["<S-tab>"] = {
            cmd = "<gv",
        },
    },
    x = {
        ["<Up>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"k\" : \"gk\"",
            opts = {
                expr = true
            }
        },
        ["<Down>"] = {
            cmd = "v:count || mode(1)[0:1] == \"no\" ? \"j\" : \"gj\"",
            opts = {
                expr = true
            }
        },
        ["p"] = {
            cmd = "p:let @+=@0<CR>:let @\"=@0<CR>",
            opts = {
                silent = true
            },
        },
    },
})
