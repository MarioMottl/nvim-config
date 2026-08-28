-- Briefly mark the landing word after a jump without changing the jumplist.
local M = {}
local ns = vim.api.nvim_create_namespace("mario_4coder_jump")

function M.flash(bufnr, row, col)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    row = row or (vim.api.nvim_win_get_cursor(0)[1] - 1)
    col = col or vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
    local start_col, end_col = col, math.min(col + 1, #line)
    local word_start, word_end = line:find("[%w_]+", math.max(1, col + 1))
    if word_start and col >= word_start - 1 and col < word_end then
        start_col, end_col = word_start - 1, word_end
    end
    if end_col <= start_col then return end
    local id = vim.api.nvim_buf_set_extmark(bufnr, ns, row, start_col, {
        end_col = end_col, hl_group = "FourCoderJump", priority = 250,
    })
    vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, id) end
    end, 450)
end

function M.after_lsp_jump()
    local origin_buf = vim.api.nvim_get_current_buf()
    local origin = vim.api.nvim_win_get_cursor(0)
    local id = vim.api.nvim_create_autocmd("CursorMoved", {
        once = true,
        callback = function()
            local now = vim.api.nvim_win_get_cursor(0)
            if vim.api.nvim_get_current_buf() ~= origin_buf or now[1] ~= origin[1] or now[2] ~= origin[2] then M.flash() end
        end,
    })
    -- A server can legitimately return no location.  Do not let that leave a
    -- stale one-shot callback that fires during an unrelated later movement.
    vim.defer_fn(function() pcall(vim.api.nvim_del_autocmd, id) end, 2000)
end

function M.setup()
    vim.api.nvim_set_hl(0, "FourCoderJump", { link = "IncSearch" })
    vim.api.nvim_create_user_command("FourCoderFlashJump", M.flash, {})
    local group = vim.api.nvim_create_augroup("MarioFourCoderJump", { clear = true })
    local previous_index
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" }, {
        group = group,
        callback = function()
            local _, index = unpack(vim.fn.getjumplist())
            if previous_index ~= nil and index ~= previous_index then
                vim.schedule(M.flash)
            end
            previous_index = index
        end,
    })
end

return M
