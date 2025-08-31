-- Autoformat on save for all LSP-supported filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,

})
