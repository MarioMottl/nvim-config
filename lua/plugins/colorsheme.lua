local active_theme = "gruvbox"

-- kanso variants: "zen", "ink", "mist", "pearl"
local kanso_variant = "ink"

if active_theme == "kanso" then
    return {
        {
            "webhooked/kanso.nvim",
            name = "kanso",
            lazy = false,
            priority = 1000,
            config = function()
                require("kanso").setup({
                    theme = kanso_variant,
                })
                vim.cmd("colorscheme kanso-" .. kanso_variant)
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "kanso-" .. kanso_variant,
            },
        },
    }
elseif active_theme == "naysayer" then
    return {
        {
            "RostislavArts/naysayer.nvim",
            name = "naysayer",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd("colorscheme naysayer")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "naysayer",
            },
        },
    }
elseif active_theme == "gruvbox" then
    return {
        {
            "ellisonleao/gruvbox.nvim",
            name = "gruvbox",
            lazy = false,
            priority = 1000,
            opts = {
                contrast = "hard", -- dark hard
                -- you can add other options here if you want
            },
            config = function(_, opts)
                vim.o.background = "dark"
                require("gruvbox").setup(opts)
                vim.cmd("colorscheme gruvbox")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "gruvbox",
            },
        },
    }
else
    error("Unknown theme: " .. active_theme)
end
