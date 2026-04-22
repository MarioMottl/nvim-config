-- Only show LSP diagnostics when the buffer is saved (not while actively editing).
-- Wraps both push (publishDiagnostics, e.g. zls) and pull (textDocument/diagnostic,
-- e.g. rust-analyzer) handlers so either path is blocked while the buffer is modified.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local pending = {} -- pending[method] = latest { err, result, ctx, config }

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
        for method, d in pairs(pending) do
          local orig = client.handlers[method]
          if orig then orig(d[1], d[2], d[3], d[4]) end
        end
        pending = {}
      end,
    })
  end,
})
