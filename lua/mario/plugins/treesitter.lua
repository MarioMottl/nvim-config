return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "bash", "c", "cpp", "json", "lua",
            "markdown", "markdown_inline",
            "rust", "toml", "vim", "vimdoc", "yaml",
        }

        if vim.fn.executable("zig") == 1 then
            table.insert(parsers, "zig")
        end

        require("nvim-treesitter").install(parsers)
    end,
}
