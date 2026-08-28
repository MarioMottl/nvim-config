-- A deliberately small, code-oriented navigation layer inspired by 4coder.
-- The implementation lives in mario.4coder.* so this plugin spec remains easy
-- to remove or customise independently of the rest of the configuration.
return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- hlchunk owns the fast Tree-sitter chunk indicator/extmark machinery.
        -- mario.4coder.scope adds the quieter nested background ranges below.
        require("hlchunk").setup({
            chunk = {
                enable = true,
                use_treesitter = true,
                style = { { fg = "#596275" }, { fg = "#7f5f5f" } },
                chars = {
                    horizontal_line = "─",
                    vertical_line = "│",
                    left_top = "┌",
                    left_bottom = "└",
                    right_arrow = "─",
                },
                delay = 80,
                duration = 100,
            },
            indent = { enable = false },
            line_num = { enable = false },
            blank = { enable = false },
        })

        require("mario.4coder.scope").setup()
        require("mario.4coder.peek").setup()
        require("mario.4coder.jump").setup()
        require("mario.4coder.signature").setup()
    end,
}
