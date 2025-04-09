-- Set this variable to either "catppuccin" or "rose-pine"
local selected_colorscheme = "rose-pine" -- change as needed

if selected_colorscheme == "catppuccin" then
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
elseif selected_colorscheme == "rose-pine" then
    return {
        {
            "rose-pine/neovim",
            name = "rose-pine",
            priority = 1000,
            config = function()
                require("rose-pine").setup({
                    dark_variant = "main", -- or "moon"
                })
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "rose-pine",
            },
        },
    }
end
