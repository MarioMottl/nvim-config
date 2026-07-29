return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- nvim-treesitter main branch removed ft_to_lang; shim for telescope compat
        if not vim.treesitter.language.ft_to_lang then
            vim.treesitter.language.ft_to_lang = function(ft)
                return vim.treesitter.language.get_lang(ft) or ft
            end
        end

        local telescope = require("telescope")
        local actions   = require("telescope.actions")
        local open_with_trouble = require("trouble.sources.telescope").open

        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", "vendor", "build", "%.git" },
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<C-t>"] = open_with_trouble,
                    },
                    n = { ["<C-t>"] = open_with_trouble },
                },
            },
        })

        telescope.load_extension("fzf")

        local keymap = vim.keymap
        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
        keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word under cursor" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Find buffers" })
    end,
}
