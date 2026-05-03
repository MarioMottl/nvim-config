-- Diagnostics on save: enabled by default.
-- Toggle with <leader>ct ("Toggle diagnostics on save").
vim.g.lsp_diag_on_save = true

vim.api.nvim_create_autocmd("LspAttach", {
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

    wrap("textDocument/publishDiagnostics") -- push (zls, most LSPs)
    wrap("textDocument/diagnostic")         -- pull (rust-analyzer, clangd, …)

    vim.api.nvim_create_autocmd("BufWritePost", {
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

vim.keymap.set("n", "<leader>ct", function()
  vim.g.lsp_diag_on_save = not vim.g.lsp_diag_on_save
  vim.notify(
    "Diagnostics on save: " .. (vim.g.lsp_diag_on_save and "ON" or "OFF (real-time)"),
    vim.log.levels.INFO,
    { title = "LSP" }
  )
end, { desc = "Toggle diagnostics on save" })

vim.keymap.set("n", "<leader>cL", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients > 0 then
    vim.lsp.stop_client(clients)
    vim.notify("LSP stopped", vim.log.levels.WARN, { title = "LSP" })
  else
    vim.api.nvim_exec_autocmds("FileType", { buf = bufnr })
    vim.notify("LSP started", vim.log.levels.INFO, { title = "LSP" })
  end
end, { desc = "Toggle LSP" })

return {}
