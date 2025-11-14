return {
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "XXiaoA/atone.nvim",
        cmd = "Atone",
        opts = {},
    },

    {
        "saghen/blink.cmp",
        version = "*",
        keys = {
            {
                "<leader>tc",
                function()
                    -- Declare the global toggle if not already present.  This
                    -- prevents multiple definitions when the module reloads.
                    if not _G.toggle_blink_cmp then
                        _G.toggle_blink_cmp = function()
                            vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
                            print("Blink CMP is now " .. (vim.g.blink_cmp_enabled and "enabled" or "disabled"))
                        end
                    end
                    _G.toggle_blink_cmp()
                end,
                desc = "Toggle Blink CMP",
            },
        },
        config = function()
            -- Define a global toggle function if it doesn't exist yet.  This
            -- makes the mapping work even if the user reloads the configuration.
            if not _G.toggle_blink_cmp then
                _G.toggle_blink_cmp = function()
                    vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
                    print("Blink CMP is now " .. (vim.g.blink_cmp_enabled and "enabled" or "disabled"))
                end
            end
            -- Enable the plugin by default.
            vim.g.blink_cmp_enabled = true
            require("blink.cmp").setup {
                -- Only enable completion when the buffer type is not a prompt and
                -- when the global toggle is true.
                enabled = function()
                    return vim.bo.buftype ~= "prompt" and vim.g.blink_cmp_enabled == true
                end,
                keymap = { preset = "default" },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },
                signature = { enabled = true },
                completion = {
                    trigger = {
                        show_on_keyword = true,
                        show_on_trigger_character = true,
                    },
                },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },
            }
        end,
    },

    {
        "mikesmithgh/kitty-scrollback.nvim",
        enabled = true,
        lazy = true,
        cmd = {
            "KittyScrollbackGenerateKittens",
            "KittyScrollbackCheckHealth",
            "KittyScrollbackGenerateCommandLineEditing",
        },
        event = { "User KittyScrollbackLaunch" },
        config = function()
            require("kitty-scrollback").setup()
        end,
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        event = {
            "BufReadPre *.md",
            "BufNewFile *.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "NOTES",
                    path = "~/notes",
                },
            },
        },
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
            { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Toggle tab terminal" },
        },
        config = function()
            require("toggleterm").setup {
                size = 20,
                open_mapping = [[<c-\>]],
            }
            function _G.set_terminal_keymaps()
                local opts = { noremap = true, silent = true }
                -- Enter terminal normal mode on <Esc> in terminal mode
                vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
                -- Toggle the terminal on <Esc><Esc> both in normal and terminal modes
                vim.api.nvim_buf_set_keymap(0, "n", "<esc><esc>", [[<cmd>ToggleTerm<CR>]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<cmd>ToggleTerm<CR>]], opts)
            end

            -- Attach the keymaps whenever a terminal buffer opens
            vim.cmd [[autocmd! TermOpen term://* lua set_terminal_keymaps()]]
        end,
    },
}
