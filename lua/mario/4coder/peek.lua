-- Non-focused, short-lived LSP definition preview.
local M = {}
local preview_win

local function close()
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
    end
    preview_win = nil
end

local function location(result)
    if vim.tbl_islist(result) then result = result[1] end
    if not result then return end
    return result.targetUri or result.uri, result.targetRange or result.range
end

function M.definition()
    local params = vim.lsp.util.make_position_params(0, "utf-16")
    vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
        if err or not result then
            vim.notify("No definition found", vim.log.levels.INFO, { title = "Peek definition" })
            return
        end
        local uri, range = location(result)
        if not uri or not range then return end
        local source = vim.uri_to_bufnr(uri)
        vim.fn.bufload(source)
        local line_count = vim.api.nvim_buf_line_count(source)
        local target = math.min(range.start.line, math.max(line_count - 1, 0))
        local first = math.max(0, target - 3)
        local last = math.min(line_count, target + 8)
        local lines = vim.api.nvim_buf_get_lines(source, first, last, false)
        local width = 1
        for _, line in ipairs(lines) do width = math.max(width, vim.fn.strdisplaywidth(line)) end
        width = math.min(math.max(width, 30), math.max(30, math.floor(vim.o.columns * 0.55)))
        close()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].filetype = vim.bo[source].filetype
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        preview_win = vim.api.nvim_open_win(buf, false, {
            relative = "cursor", row = 1, col = 2,
            width = width, height = math.min(#lines, 11),
            style = "minimal", border = "rounded", focusable = false,
            title = " definition ", title_pos = "center",
        })
        local preview_row = target - first + 1
        vim.api.nvim_win_set_cursor(preview_win, {
            preview_row, math.min(range.start.character, #(lines[preview_row] or "")),
        })
        vim.defer_fn(close, 4000)
    end)
end

function M.setup()
    vim.api.nvim_create_user_command("FourCoderPeekDefinition", M.definition, {})
    local group = vim.api.nvim_create_augroup("MarioFourCoderPeek", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, { group = group, callback = close })
end

return M
