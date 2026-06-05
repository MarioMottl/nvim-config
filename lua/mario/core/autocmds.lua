local autocmd = vim.api.nvim_create_autocmd

-- Relative numbers in normal mode, absolute in insert
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
        end
    end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    pattern = "*",
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
})

-- Diagnostics-on-save: buffer pending diagnostics until BufWritePost
autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local pending = {}

        local function get_bufnr(result, ctx)
            if ctx and ctx.bufnr and vim.api.nvim_buf_is_valid(ctx.bufnr) then
                return ctx.bufnr
            end
            if result and result.uri then
                return vim.uri_to_bufnr(result.uri)
            end
        end

        local function wrap(method)
            local orig = client.handlers[method] or vim.lsp.handlers[method]
            if not orig then return end
            client.handlers[method] = function(err, result, ctx, config)
                if not vim.g.lsp_diag_on_save then
                    return orig(err, result, ctx, config)
                end
                local bufnr = get_bufnr(result, ctx)
                if bufnr and vim.bo[bufnr].modified then
                    pending[method] = { err, result, ctx, config }
                    return
                end
                orig(err, result, ctx, config)
            end
        end

        wrap("textDocument/publishDiagnostics")
        wrap("textDocument/diagnostic")

        autocmd("BufWritePost", {
            buffer = args.buf,
            callback = function()
                if not vim.g.lsp_diag_on_save then return end
                for method, d in pairs(pending) do
                    local orig = client.handlers[method]
                    if orig then orig(d[1], d[2], d[3], d[4]) end
                end
                pending = {}
            end,
        })
    end,
})
