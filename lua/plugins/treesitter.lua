return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local parsers = { "c", "cpp", "rust", "lua", "vim", "vimdoc" }

            -- zig parser only available if zig toolchain is present
            if vim.fn.executable("zig") == 1 then
                table.insert(parsers, "zig")
            end

            require("nvim-treesitter").install(parsers)
        end,
    },
}
