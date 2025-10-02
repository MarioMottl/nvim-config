-- Set relative line numbers in visual mode, absolute in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.opt.relativenumber = false
        vim.opt.number = true
    end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "ModeChanged" }, {
    callback = function()
        local mode = vim.fn.mode()
        if mode == "n" or mode:match("v") then
            vim.opt.relativenumber = true
            vim.opt.number = true
        end
    end,
})
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

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.poi",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
    end,
})
