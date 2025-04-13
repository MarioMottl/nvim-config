return {
    {
        "savq/melange-nvim",
        name = "melange",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme melange")
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "melange",
        },
    },
}
