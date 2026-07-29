vim.g.mapleader = " "

local keymap = vim.keymap
local state = require("mario.core.state")

-- Paste without clobbering register in visual mode
keymap.set("x", "p", '"_dP', { noremap = true, silent = true })
keymap.set("x", "P", '"_dP', { noremap = true, silent = true })

-- Move selected lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Window splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Resize splits
keymap.set("n", "<C-Up>",    ":resize +2<CR>",          { desc = "Taller" })
keymap.set("n", "<C-Down>",  ":resize -2<CR>",          { desc = "Shorter" })
keymap.set("n", "<C-Left>",  ":vertical resize -4<CR>", { desc = "Narrower" })
keymap.set("n", "<C-Right>", ":vertical resize +4<CR>", { desc = "Wider" })

-- Buffer navigation (BufferLine)
keymap.set("n", "<Tab>",   "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
keymap.set("n", "<leader>h", ":BufferLineMovePrev<CR>", { silent = true, desc = "Move buffer left" })
keymap.set("n", "<leader>l", ":BufferLineMoveNext<CR>", { silent = true, desc = "Move buffer right" })

-- Delete buffer without closing split
keymap.set("n", "<leader>x", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("bnext")
    vim.cmd("bdelete " .. buf)
end, { desc = "Close buffer (keep split)" })

keymap.set("n", "<leader>bd", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("bnext")
    vim.cmd("bdelete " .. buf)
end, { desc = "Delete buffer (keep split)" })

keymap.set("n", "<leader>n", "<cmd>tabnew<CR>", { desc = "New tab" })

-- LSP extras (Telescope)
keymap.set("n", "<leader>ci", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Find callers of this function" })
keymap.set("n", "<leader>co", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "Find functions called from here" })
keymap.set("n", "<leader>ch", "<cmd>Telescope lsp_implementations<CR>", { desc = "Find implementations" })
keymap.set("n", "<leader>cu", "<cmd>Telescope lsp_references<CR>",      { desc = "Find references and usages" })

-- Search pattern → quickfix
keymap.set("n", "<leader>sq", function()
    local pattern = vim.fn.getreg("/")
    if pattern == "" then
        vim.notify("No search pattern", vim.log.levels.WARN)
        return
    end
    local ok = pcall(vim.cmd, "vimgrep /" .. pattern:gsub("/", "\\/") .. "/g %")
    if ok then
        vim.cmd("copen")
    else
        vim.notify("No matches for: " .. pattern, vim.log.levels.INFO)
    end
end, { desc = "Search → quickfix" })

-- Theme switcher
keymap.set("n", "<leader>ts", "<cmd>Theme<CR>",      { desc = "Select theme" })
keymap.set("n", "<leader>tn", "<cmd>ThemeNext<CR>",  { desc = "Next theme" })
keymap.set("n", "<leader>tp", "<cmd>ThemePrev<CR>",  { desc = "Prev theme" })

-- Toggle diagnostics on save
vim.g.lsp_diag_on_save = state.get("lsp_diag_on_save", true)

keymap.set("n", "<leader>ct", function()
    vim.g.lsp_diag_on_save = not vim.g.lsp_diag_on_save
    state.set("lsp_diag_on_save", vim.g.lsp_diag_on_save)
    vim.notify(
        "Diagnostics on save: " .. (vim.g.lsp_diag_on_save and "ON" or "OFF (real-time)"),
        vim.log.levels.INFO, { title = "LSP" }
    )
end, { desc = "Toggle diagnostics: save/live" })

-- Toggle completion without stopping LSP features such as diagnostics
vim.g.cmp_enabled = state.get("cmp_enabled", true)

keymap.set("n", "<leader>cc", function()
    vim.g.cmp_enabled = not vim.g.cmp_enabled
    state.set("cmp_enabled", vim.g.cmp_enabled)

    if not vim.g.cmp_enabled and package.loaded.cmp then
        require("cmp").abort()
    end

    vim.notify(
        "Completion: " .. (vim.g.cmp_enabled and "ON" or "OFF (LSP still active)"),
        vim.log.levels.INFO, { title = "nvim-cmp" }
    )
end, { desc = "Toggle completion popup" })

-- Toggle LSP
vim.g.lsp_enabled = state.get("lsp_enabled", true)

keymap.set("n", "<leader>cL", function()
    vim.g.lsp_enabled = not vim.g.lsp_enabled
    state.set("lsp_enabled", vim.g.lsp_enabled)

    local servers = { "clangd", "rust_analyzer", "zls", "lua_ls" }
    require("lazy").load({ plugins = { "nvim-lspconfig" } })
    for _, server in ipairs(servers) do
        vim.lsp.enable(server, vim.g.lsp_enabled)
    end

    if not vim.g.lsp_enabled then
        local clients = vim.tbl_filter(function(client)
            return vim.tbl_contains(servers, client.name)
        end, vim.lsp.get_clients())
        for _, client in ipairs(clients) do
            client:stop()
        end
    end

    vim.notify(
        "Language servers: " .. (vim.g.lsp_enabled and "ON" or "OFF"),
        vim.g.lsp_enabled and vim.log.levels.INFO or vim.log.levels.WARN,
        { title = "LSP" }
    )
end, { desc = "Toggle language server" })
