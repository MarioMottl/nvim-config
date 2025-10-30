local active_theme = "naysayer"

-- kanso variants: "zen", "ink", "pearl"
local kanso_variant = "zen"

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
else
    error("Unknown theme: " .. active_theme)
end
