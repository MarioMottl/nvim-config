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

-- Highlight the word under the cursor without moving to another match.
local function highlight_cword(search_forward)
    local word = vim.fn.expand("<cword>")
    if word == "" then
        return
    end

    vim.fn.setreg("/", "\\<" .. vim.fn.escape(word, "\\.*~[") .. "\\>")
    vim.v.searchforward = search_forward and 1 or 0
    vim.opt.hlsearch = true
    vim.cmd("redraw")
end

keymap.set("n", "<leader>*", function()
    highlight_cword(true)
end, { desc = "Highlight word (forward)" })

keymap.set("n", "<leader>#", function()
    highlight_cword(false)
end, { desc = "Highlight word (backward)" })

-- LSP extras (Snacks)
keymap.set("n", "<leader>ci", function() Snacks.picker.lsp_incoming_calls() end, { desc = "Find callers of this function" })
keymap.set("n", "<leader>co", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "Find functions called from here" })
keymap.set("n", "<leader>ch", function() Snacks.picker.lsp_implementations() end, { desc = "Find implementations" })
keymap.set("n", "<leader>cu", function() Snacks.picker.lsp_references() end, { desc = "Find references and usages" })
keymap.set("n", "<leader>cs", function()
    require("mario.4coder.scope").toggle_backgrounds()
end, { desc = "Toggle 4coder scope backgrounds" })
keymap.set("n", "<leader>ck", function()
    require("mario.4coder.signature").show()
end, { desc = "Show function parameters" })

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

-- Toggle between automatic completion popups and manual-only completion.
-- In manual mode, <C-Space> still opens the completion menu in insert mode.
vim.g.cmp_manual = state.get("cmp_manual", false)

keymap.set("n", "<leader>cc", function()
    vim.g.cmp_manual = not vim.g.cmp_manual
    state.set("cmp_manual", vim.g.cmp_manual)

    require("lazy").load({ plugins = { "nvim-cmp" } })
    local cmp = require("cmp")
    cmp.abort()
    cmp.setup({
        completion = {
            autocomplete = not vim.g.cmp_manual and { cmp.TriggerEvent.TextChanged } or false,
        },
    })

    vim.notify(
        "Completion: " .. (vim.g.cmp_manual and "manual (<C-Space> to show)" or "auto"),
        vim.log.levels.INFO,
        { title = "nvim-cmp" }
    )
end, { desc = "Toggle completion auto/manual" })

-- Toggle inlay hints globally and remember the choice across restarts.
vim.g.inlay_hints_enabled = state.get("inlay_hints_enabled", true)

keymap.set("n", "<leader>cI", function()
    vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
    state.set("inlay_hints_enabled", vim.g.inlay_hints_enabled)

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local ft = vim.bo[bufnr].filetype
            local path = vim.api.nvim_buf_get_name(bufnr)
            local excluded = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)
                or path:match("%.h$") or path:match("%.hh$")
                or path:match("%.hpp$") or path:match("%.hxx$")
                or path:match("%.inl$")

            vim.lsp.inlay_hint.enable(
                vim.g.inlay_hints_enabled and not excluded,
                { bufnr = bufnr }
            )
        end
    end

    vim.notify(
        "Inlay hints: " .. (vim.g.inlay_hints_enabled and "ON" or "OFF"),
        vim.log.levels.INFO,
        { title = "LSP" }
    )
end, { desc = "Toggle inlay hints" })

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
