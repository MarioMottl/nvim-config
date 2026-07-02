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
                lualine_b = {
                    {
                        function()
                            local reg = vim.fn.reg_recording()
                            if reg == "" then return "" end
                            return "recording @" .. reg
                        end,
                    },
                },
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
