-- "zen" "ink" "pearl"
local kanso_variant = "zen"

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
