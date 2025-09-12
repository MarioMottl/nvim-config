local fmt_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmt_group,
    callback = function(args)
        local bufnr = args.buf

        local function supports(method)
            for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                if c.supports_method and c.supports_method(method) then
                    return true
                end
            end
            return false
        end

        if supports("textDocument/formatting") then
            vim.lsp.buf.format({
                async = false,
                bufnr = bufnr,
                filter = function(client)
                    return client.supports_method and client.supports_method("textDocument/formatting")
                end,
            })
        end
    end,
})
