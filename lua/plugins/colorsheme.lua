return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
                integrations = {
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                    },
                    telescope = true,
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                },
            })
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },
}
