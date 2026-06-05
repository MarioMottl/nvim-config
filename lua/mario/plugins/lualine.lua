return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "",
            },
            sections = {
                lualine_x = { { "encoding" }, { "fileformat" }, { "filetype" } },
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
