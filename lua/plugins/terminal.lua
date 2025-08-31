-- plugins/terminal.lua
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            -- Toggle floating terminal with <leader>tf
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
            -- Toggle terminal in a new tab with <leader>tt
            { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Toggle tab terminal" },
        },
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]], -- or "<c-\\>" with escaped backslash
            })

            -- Function to set custom key mappings for terminal buffers
            function _G.set_terminal_keymaps()
                local opts = { noremap = true, silent = true }

                -- 1) In terminal mode, pressing <Esc> once => go to terminal normal mode
                vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)

                -- 2) In terminal normal mode, pressing <Esc><Esc> => toggle/close the terminal
                vim.api.nvim_buf_set_keymap(0, "n", "<esc><esc>", [[<cmd>ToggleTerm<CR>]], opts)

                -- 3) In terminal terminal mode, pressing <Esc><Esc> => toggle/close the terminal
                vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<cmd>ToggleTerm<CR>]], opts)
            end

            -- Auto-apply the keymaps when a terminal buffer is opened
            vim.cmd([[autocmd! TermOpen term://* lua set_terminal_keymaps()]])
        end,
    },
}
