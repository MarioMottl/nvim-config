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
                keymap.set("n", "gR", function()
                    require("mario.4coder.jump").after_lsp_jump()
                    Snacks.picker.lsp_references()
                end, opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", function()
                    require("mario.4coder.jump").after_lsp_jump()
                    vim.lsp.buf.declaration()
                end, opts)

                opts.desc = "Go to definition"
                keymap.set("n", "gd", function()
                    require("mario.4coder.jump").after_lsp_jump()
                    vim.lsp.buf.definition()
                end, opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", function()
                    require("mario.4coder.jump").after_lsp_jump()
                    Snacks.picker.lsp_implementations()
                end, opts)

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", function()
                    require("mario.4coder.jump").after_lsp_jump()
                    Snacks.picker.lsp_type_definitions()
                end, opts)

                opts.desc = "Peek LSP definition"
                keymap.set("n", "<leader>cp", require("mario.4coder.peek").definition, opts)

                opts.desc = "Show available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Buffer diagnostics"
                keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, opts)

                opts.desc = "Show diagnostics for current line"
                keymap.set("n", "<leader>d", function()
                    vim.diagnostic.open_float(nil, {
                        scope = "line",
                        border = "rounded",
                        source = "if_many",
                    })
                end, opts)

                opts.desc = "Prev diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                opts.desc = "Next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                opts.desc = "Hover docs"
                keymap.set("n", "K", function()
                    vim.lsp.buf.hover({ border = "rounded" })
                end, opts)

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
                    -- Neovim can cache visible lines before the first hints arrive.
                    -- Refresh once after that response so those lines are drawn too.
                    local refresh_autocmd
                    refresh_autocmd = vim.api.nvim_create_autocmd("LspRequest", {
                        buffer = ev.buf,
                        callback = function(request_ev)
                            if request_ev.data.client_id ~= client.id
                                or request_ev.data.request.method ~= "textDocument/inlayHint"
                                or request_ev.data.request.type ~= "complete" then
                                return
                            end

                            vim.api.nvim_del_autocmd(refresh_autocmd)
                            vim.schedule(function()
                                if vim.api.nvim_buf_is_loaded(ev.buf)
                                    and vim.g.inlay_hints_enabled
                                    and vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }) then
                                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                                end
                            end)
                        end,
                    })
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
