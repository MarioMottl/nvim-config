-- Load persisted completion state before blink.cmp initializes.
do
  local s = require("config.state").load()
  vim.g.blink_cmp_manual = s.blink_cmp_manual == true
end

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
            {
                "<leader>uk",
                function()
                    toggle_blink_cmp_manual()
                end,
                desc = "Toggle completion auto/manual",
            },
        },
        config = function()
            function _G.toggle_blink_cmp()
                vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
                print("Blink CMP is now " .. (vim.g.blink_cmp_enabled and "enabled" or "disabled"))
            end

            -- Toggle between auto-show and manual-only (C-Space) completion.
            function _G.toggle_blink_cmp_manual()
                vim.g.blink_cmp_manual = not vim.g.blink_cmp_manual
                local cfg = require("blink.cmp.config")
                cfg.completion.trigger.show_on_keyword = not vim.g.blink_cmp_manual
                cfg.completion.trigger.show_on_trigger_character = not vim.g.blink_cmp_manual
                local st = require("config.state")
                local s = st.load()
                s.blink_cmp_manual = vim.g.blink_cmp_manual
                st.save(s)
                vim.notify(
                    "Completion: " .. (vim.g.blink_cmp_manual and "manual (<C-Space> to show)" or "auto"),
                    vim.log.levels.INFO,
                    { title = "Blink" }
                )
            end

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
                        show_on_keyword = not vim.g.blink_cmp_manual,
                        show_on_trigger_character = not vim.g.blink_cmp_manual,
                    },
                },

                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },
            })
        end,
    },
}
