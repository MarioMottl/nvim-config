-- lua/plugins/lsp.lua
return {
    {
        "saghen/blink.cmp",
        lazy = false,
        priority = 10000,
        version = "*",
        opts = function(_, opts)
            opts.sources = {
                default = { "lsp", "path", "buffer" },
                providers = {
                    snippets = { enabled = false }, -- kill giant snippet templates
                    lazydev = { enabled = false },
                },
            }
            opts.documentation = { auto_show = false }
            opts.keymap = {
                preset = "enter",
                ["<C-y>"] = { "accept" }, -- confirm with Ctrl-Y
            }
            return opts
        end,
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        priority = 9000,
        config = function()
            local caps = vim.lsp.protocol.make_client_capabilities()
            local ok, blink = pcall(require, "blink.cmp")
            if ok and blink.get_lsp_capabilities then
                caps = blink.get_lsp_capabilities(caps)
            end
            -- NOTE: do NOT disable snippetSupport — LSP needs it for parens/args

            local on_attach = function(client, bufnr)
                client.server_capabilities.semanticTokensProvider = nil
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                local map = function(m, lhs, rhs)
                    vim.keymap.set(m, lhs, rhs, { buffer = bufnr, silent = true })
                end
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = false })
                end)
            end

            local lspconfig = require("lspconfig")
            for _, name in ipairs({ "rust_analyzer", "pyright", "bashls", "marksman", "clangd" }) do
                lspconfig[name].setup({ capabilities = caps, on_attach = on_attach })
            end

            lspconfig.lua_ls.setup({
                capabilities = caps,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })
        end,
    },
}
