return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("MarioLualineSync", { clear = true }),
            callback = function()
                lualine.refresh()
            end,
        })
    end,
}
