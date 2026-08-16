return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap

        -- Keymaps on LspAttach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("MarioLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                -- Disable semantic tokens (keep treesitter highlighting)
                if client and client.server_capabilities.semanticTokensProvider then
                    client.server_capabilities.semanticTokensProvider = nil
                end

                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Go to definition"
                keymap.set("n", "gd", vim.lsp.buf.definition, opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "Show available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Prev diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                opts.desc = "Next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                opts.desc = "Hover docs"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

                -- Inlay hints: enabled for all except C/C++ headers
                local ft   = vim.bo[ev.buf].filetype
                local path = vim.api.nvim_buf_get_name(ev.buf)
                local no_hints = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)
                    or path:match("%.h$") or path:match("%.hh$")
                    or path:match("%.hpp$") or path:match("%.hxx$")
                    or path:match("%.inl$")

                if client and client.server_capabilities.inlayHintProvider
                    and vim.g.inlay_hints_enabled and not no_hints then
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                end
            end,
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()
        -- Ask language servers for plain completion text instead of function-call
        -- snippets with argument placeholders (for example, print(fmt, args)).
        capabilities.textDocument.completion.completionItem.snippetSupport = false

        -- Diagnostic signs
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
        end

        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 2 },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Clangd
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--query-driver=/usr/bin/c++,/usr/bin/g++",
            },
            init_options = {
                fallbackFlags = { "-std=c++20" },
            },
        })
        if vim.g.lsp_enabled then
            vim.lsp.enable("clangd")
        end

        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(ev)
                local ft = vim.bo[ev.buf].filetype
                local cpp_like = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)
                local fmt_fts  = { "rust", "zig", "lua" }

                if cpp_like then
                    vim.lsp.buf.format({
                        bufnr = ev.buf,
                        async = false,
                        filter = function(client) return client.name == "clangd" end,
                    })
                elseif vim.tbl_contains(fmt_fts, ft) then
                    local clients = vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" })
                    if #clients > 0 then
                        vim.lsp.buf.format({ bufnr = ev.buf, async = false })
                    end
                end
            end,
        })

        -- Rust Analyzer
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        typeHints            = { enable = true },
                        parameterHints       = { enable = false },
                        chainingHints        = { enable = false },
                        bindingModeHints     = { enable = false },
                        closureReturnTypeHints = { enable = "never" },
                        lifetimeElisionHints = { enable = "never" },
                        reborrowHints        = { enable = false },
                        closingBraceHints    = { enable = false },
                    },
                },
            },
        })
        if vim.g.lsp_enabled then
            vim.lsp.enable("rust_analyzer")
        end

        -- ZLS (Zig)
        vim.lsp.config("zls", {
            capabilities = capabilities,
        })
        if vim.g.lsp_enabled then
            vim.lsp.enable("zls")
        end

        -- Lua LS
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    completion = { callSnippet = "Replace" },
                },
            },
        })
        if vim.g.lsp_enabled then
            vim.lsp.enable("lua_ls")
        end
    end,
}
