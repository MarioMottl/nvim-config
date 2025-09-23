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
            -- global toggle (default on) for semantic tokens
            if vim.g.semantic_tokens_enabled == nil then
                vim.g.semantic_tokens_enabled = true
            end

            -- Fallback linking for common semantic token highlight groups if theme doesn't define them.
            local function ensure_semantic_hl_links()
                local links = {
                    ["@lsp.type.variable"] = "@variable",
                    ["@lsp.type.parameter"] = "@parameter",
                    ["@lsp.type.property"] = "@property",
                    ["@lsp.type.function"] = "@function",
                    ["@lsp.type.method"] = "@method",
                    ["@lsp.type.namespace"] = "@namespace",
                    ["@lsp.type.class"] = "@type",
                    ["@lsp.typemod.variable.readonly"] = "@constant",
                }
                for group, target in pairs(links) do
                    local ok_hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
                    if not ok_hl then
                        pcall(vim.api.nvim_set_hl, 0, group, { link = target })
                    end
                end
            end

            ensure_semantic_hl_links()

            local function enable_semantic_tokens(client, bufnr)
                if not vim.g.semantic_tokens_enabled then return end
                local caps = client.server_capabilities
                if caps and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
                    -- Start semantic tokens for this buffer/client pair
                    pcall(vim.lsp.semantic_tokens.start, bufnr, client.id)
                    -- Refresh on edits & mode transitions (avoid spamming)
                    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = function()
                            if vim.api.nvim_buf_is_valid(bufnr)
                                and client.server_capabilities.semanticTokensProvider then
                                pcall(vim.lsp.semantic_tokens.refresh, bufnr)
                            end
                        end,
                    })
                end
            end

            -- User command to toggle semantic tokens globally
            if not vim.g._semantic_tokens_toggle_defined then
                vim.api.nvim_create_user_command("SemanticTokensToggle", function()
                    vim.g.semantic_tokens_enabled = not vim.g.semantic_tokens_enabled
                    local state = vim.g.semantic_tokens_enabled and "enabled" or "disabled"
                    print("Semantic tokens " .. state)
                    -- Apply state to all attached buffers
                    for _, client in pairs(vim.lsp.get_clients()) do
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if vim.lsp.buf_is_attached(buf, client.id) then
                                if vim.g.semantic_tokens_enabled then
                                    enable_semantic_tokens(client, buf)
                                else
                                    pcall(vim.lsp.semantic_tokens.stop, buf, client.id)
                                end
                            end
                        end
                    end
                end, {})
                vim.g._semantic_tokens_toggle_defined = true
            end

            local on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                -- Local helper for capability checks
                local function supports(method)
                    for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                        if c.supports_method and c.supports_method(method) then
                            return true
                        end
                    end
                    return false
                end

                local map = function(m, lhs, rhs)
                    vim.keymap.set(m, lhs, rhs, { buffer = bufnr, silent = true })
                end
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "<leader>f", function()
                    if supports("textDocument/formatting") then
                        vim.lsp.buf.format({ async = false })
                    end
                end)

                enable_semantic_tokens(client, bufnr)
            end

            local lspconfig = require("lspconfig")
            for _, name in ipairs({ "rust_analyzer", "pyright", "bashls", "marksman" }) do
                lspconfig[name].setup({ capabilities = caps, on_attach = on_attach })
            end

            lspconfig.clangd.setup({
                capabilities = caps,
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--query-driver=/nix/store/*/bin/*,/run/current-system/sw/bin/*,/usr/bin/*",
                },
            })

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
