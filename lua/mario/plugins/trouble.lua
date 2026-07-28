return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        {
            "<leader>qD",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Workspace diagnostics",
        },
        {
            "<leader>qd",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer diagnostics",
        },
        {
            "<leader>qq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix list",
        },
        {
            "<leader>ql",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location list",
        },
        {
            "<leader>qs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Document symbols",
        },
    },
}
