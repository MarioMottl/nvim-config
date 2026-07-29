return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.g.which_key_enabled = true
    end,
    opts = {
        preset = "classic",
        delay = 350,
        filter = function()
            return vim.g.which_key_enabled
        end,
        win = {
            no_overlap = false,
            width = 0.32,
            height = { min = 4, max = 18 },
            col = math.huge,
            row = math.huge,
            border = "rounded",
            padding = { 0, 1 },
            title = false,
        },
        layout = {
            width = { min = 18, max = 28 },
            spacing = 2,
            align = "left",
        },
        icons = {
            mappings = false,
            separator = "→",
        },
        show_help = false,
        show_keys = false,
        spec = {
            { "<leader>b", group = "buffers" },
            { "<leader>c", group = "code" },
            {
                "<leader>cc",
                desc = function()
                    return "Completion popup [" .. (vim.g.cmp_enabled and "ON" or "OFF") .. "]"
                end,
            },
            {
                "<leader>cL",
                desc = function()
                    return "Language servers [" .. (vim.g.lsp_enabled and "ON" or "OFF") .. "]"
                end,
            },
            {
                "<leader>ct",
                desc = function()
                    return "Diagnostics [" .. (vim.g.lsp_diag_on_save and "SAVE" or "LIVE") .. "]"
                end,
            },
            {
                "<leader>cw",
                desc = function()
                    return "Keybinding popup [" .. (vim.g.which_key_enabled and "ON" or "OFF") .. "]"
                end,
            },
            { "<leader>f", group = "find" },
            { "<leader>g", group = "git" },
            { "<leader>o", group = "obsidian" },
            { "<leader>q", group = "diagnostics" },
            { "<leader>s", group = "search/splits" },
            { "<leader>t", group = "terminal/theme" },
        },
    },
    config = function(_, opts)
        require("which-key").setup(opts)

        vim.keymap.set("n", "<leader>cw", function()
            vim.g.which_key_enabled = not vim.g.which_key_enabled
            vim.notify(
                "Keybinding popup: " .. (vim.g.which_key_enabled and "ON" or "OFF"),
                vim.log.levels.INFO,
                { title = "which-key" }
            )
        end, { desc = "Toggle keybinding popup" })
    end,
}
