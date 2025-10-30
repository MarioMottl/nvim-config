require("config.lazy")
vim.opt.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = false
vim.opt.list = true
vim.keymap.set("x", "p", '"_dP', { noremap = true, silent = true })
vim.keymap.set("x", "P", '"_dP', { noremap = true, silent = true })

-- Normal mode relative numbers insert mode absolute numbers
vim.opt.number = true
vim.opt.relativenumber = true
local number_toggle = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
    group = number_toggle,
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = number_toggle,
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})
