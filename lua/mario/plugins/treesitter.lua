return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            config = function()
                require("nvim-treesitter-textobjects").setup({
                    select = {
                        lookahead = true,
                        selection_modes = {
                            ["@parameter.outer"] = "v",
                            ["@function.outer"] = "V",
                            ["@class.outer"] = "V",
                        },
                    },
                    move = { set_jumps = true },
                })

                local select = require("nvim-treesitter-textobjects.select")
                local move = require("nvim-treesitter-textobjects.move")
                local swap = require("nvim-treesitter-textobjects.swap")

                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { desc = desc })
                end

                map({ "x", "o" }, "af", function()
                    select.select_textobject("@function.outer", "textobjects")
                end, "Around function")
                map({ "x", "o" }, "if", function()
                    select.select_textobject("@function.inner", "textobjects")
                end, "Inside function")
                map({ "x", "o" }, "ac", function()
                    select.select_textobject("@class.outer", "textobjects")
                end, "Around class")
                map({ "x", "o" }, "ic", function()
                    select.select_textobject("@class.inner", "textobjects")
                end, "Inside class")
                map({ "x", "o" }, "aa", function()
                    select.select_textobject("@parameter.outer", "textobjects")
                end, "Around argument")
                map({ "x", "o" }, "ia", function()
                    select.select_textobject("@parameter.inner", "textobjects")
                end, "Inside argument")

                map({ "n", "x", "o" }, "]m", function()
                    move.goto_next_start("@function.outer", "textobjects")
                end, "Next function")
                map({ "n", "x", "o" }, "[m", function()
                    move.goto_previous_start("@function.outer", "textobjects")
                end, "Previous function")
                map({ "n", "x", "o" }, "]]", function()
                    move.goto_next_start("@class.outer", "textobjects")
                end, "Next class")
                map({ "n", "x", "o" }, "[[", function()
                    move.goto_previous_start("@class.outer", "textobjects")
                end, "Previous class")

                map("n", "<leader>sn", function()
                    swap.swap_next("@parameter.inner")
                end, "Swap with next argument")
                map("n", "<leader>sp", function()
                    swap.swap_previous("@parameter.inner")
                end, "Swap with previous argument")
            end,
        },
    },
    config = function()
        local parsers = {
            "bash", "c", "cpp", "json", "lua",
            "markdown", "markdown_inline",
            "rust", "toml", "vim", "vimdoc", "yaml",
        }

        if vim.fn.executable("zig") == 1 then
            table.insert(parsers, "zig")
        end

        require("nvim-treesitter").install(parsers)
    end,
}
