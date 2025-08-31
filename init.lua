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

vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
