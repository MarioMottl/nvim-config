return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        picker = {
            enabled = true,
            ui_select = true,
            sources = {
                select = {
                    kinds = {
                        codeaction = {
                            focus = "list",
                            layout = {
                                hidden = { "input", "preview" },
                                layout = {
                                    relative = "cursor",
                                    row = 1,
                                    col = 0,
                                },
                            },
                            win = {
                                list = {
                                    keys = {
                                        ["h"] = "cancel",
                                        ["j"] = "list_down",
                                        ["k"] = "list_up",
                                        ["l"] = "confirm",
                                        ["i"] = false,
                                        ["a"] = false,
                                        ["/"] = false,
                                    },
                                },
                            },
                        },
                    },
                },
            },
            exclude = { "node_modules", "vendor", "build", ".git" },
            actions = {
                trouble_open = function(...)
                    return require("trouble.sources.snacks").actions.trouble_open.action(...)
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<C-j>"] = { "list_down", mode = { "n", "i" } },
                        ["<C-k>"] = { "list_up", mode = { "n", "i" } },
                        ["<C-q>"] = { "qflist", mode = { "n", "i" } },
                        ["<C-t>"] = { "trouble_open", mode = { "n", "i" } },
                    },
                },
                list = {
                    keys = {
                        ["<C-t>"] = "trouble_open",
                    },
                },
            },
        },
    },
    keys = {
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
        { "<leader>fw", function() Snacks.picker.grep() end, desc = "Live grep" },
        { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
    },
}
