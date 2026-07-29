local M = {}

local float = {
    buf = nil,
    win = nil,
}

local function float_config()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.75)

    return {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
    }
end

function M.toggle_float()
    if float.win and vim.api.nvim_win_is_valid(float.win) then
        vim.api.nvim_win_close(float.win, true)
        float.win = nil
        return
    end

    if not float.buf or not vim.api.nvim_buf_is_valid(float.buf) then
        float.buf = vim.api.nvim_create_buf(false, true)
    end

    float.win = vim.api.nvim_open_win(float.buf, true, float_config())
    if vim.bo[float.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
    end
    vim.cmd.startinsert()
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("MarioTerminal", { clear = true }),
    callback = function(args)
        vim.bo[args.buf].buflisted = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd.startinsert()

        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("MarioTerminalResize", { clear = true }),
    callback = function()
        if float.win and vim.api.nvim_win_is_valid(float.win) then
            vim.api.nvim_win_set_config(float.win, float_config())
        end
    end,
})

vim.keymap.set({ "n", "t" }, "<leader>tf", function()
    if vim.fn.mode():sub(1, 1) == "t" then
        vim.cmd.stopinsert()
    end
    M.toggle_float()
end, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<leader>th", "<cmd>botright 15split | terminal<CR>", { desc = "Open horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>botright vsplit | terminal<CR>", { desc = "Open vertical terminal" })

return M
