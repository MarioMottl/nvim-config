return {
    {
        "saghen/blink.cmp",
        version = "*",
        keys = {
            {
                "<leader>tc",
                function()
                    toggle_blink_cmp()
                end,
                desc = "Toggle Blink CMP",
            },
        },
        config = function()
            -- Define a global toggle function so that the keys mapping can call it.
            function _G.toggle_blink_cmp()
                vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
                print("Blink CMP is now " .. (vim.g.blink_cmp_enabled and "enabled" or "disabled"))
            end

            -- Set the global toggle variable to true by default.
            vim.g.blink_cmp_enabled = true
            require("blink.cmp").setup({
                -- The enabled function checks that:
                --   1. The buffer type is not "prompt"
                --   2. The global toggle is true.
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
            })
        end,
    },
}
