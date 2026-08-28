-- Small, non-focused parameter hint modelled after 4coder's call popup.
local M = {}

local signature_win
local generation = 0

local function close()
    generation = generation + 1
    if signature_win and vim.api.nvim_win_is_valid(signature_win) then
        vim.api.nvim_win_close(signature_win, true)
    end
    signature_win = nil
end

local function parameter_range(label, parameter)
    if not parameter or not parameter.label then return end
    if type(parameter.label) == "string" then
        local first, last = label:find(parameter.label, 1, true)
        return first and first - 1, last
    end
    if type(parameter.label) == "table" then
        local ok1, first = pcall(vim.str_byteindex, label, parameter.label[1], true)
        local ok2, last = pcall(vim.str_byteindex, label, parameter.label[2], true)
        if ok1 and ok2 then return first, last end
    end
end

local function display(result, request_id)
    if request_id ~= generation or not result or not result.signatures then return end
    local signature = result.signatures[(result.activeSignature or 0) + 1] or result.signatures[1]
    if not signature or not signature.label then return end

    local label = signature.label:gsub("\n", " ")
    local max_width = math.max(36, math.floor(vim.o.columns * 0.65))
    if vim.fn.strdisplaywidth(label) > max_width then
        label = label:sub(1, max_width - 3) .. "..."
    end

    close()
    -- close() increments generation; retain this response as the current one.
    generation = request_id
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { label })
    vim.bo[buf].modifiable = false
    local width = math.max(1, vim.fn.strdisplaywidth(label))
    signature_win = vim.api.nvim_open_win(buf, false, {
        relative = "cursor", row = 1, col = 1,
        width = width, height = 1, style = "minimal", border = "rounded",
        focusable = false, title = " parameters ", title_pos = "center",
    })

    local parameter = signature.parameters and signature.parameters[(result.activeParameter or 0) + 1]
    local first, last = parameter_range(label, parameter)
    if first and last and first < #label then
        vim.api.nvim_buf_add_highlight(buf, -1, "FourCoderActiveParameter", 0, first, math.min(last, #label))
    end
end

function M.show()
    local bufnr = vim.api.nvim_get_current_buf()
    local request_id = generation + 1
    generation = request_id
    local params = vim.lsp.util.make_position_params(0, "utf-16")
    vim.lsp.buf_request(bufnr, "textDocument/signatureHelp", params, function(err, result)
        if not err then display(result, request_id) end
    end)
end

function M.setup()
    vim.api.nvim_set_hl(0, "FourCoderActiveParameter", { link = "IncSearch" })
    vim.api.nvim_create_user_command("FourCoderSignatureHelp", M.show, {})
    local group = vim.api.nvim_create_augroup("MarioFourCoderSignature", { clear = true })
    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = group,
        callback = function()
            local char = vim.v.char
            if char == ")" then
                vim.schedule(close)
            elseif char == "(" or char == "," then
                vim.defer_fn(M.show, 20)
            end
        end,
    })
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "CursorMoved" }, {
        group = group,
        callback = close,
    })
end

return M
