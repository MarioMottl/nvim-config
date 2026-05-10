-- Close buffer without closing the split
vim.keymap.set("n", "<leader>bd", function()
  if pcall(require, "snacks") then
    Snacks.bufdelete()
  else
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("bnext")
    vim.cmd("bdelete " .. buf)
  end
end, { desc = "Delete buffer (keep split)" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Toggle auto pairs (mini.pairs) — state persisted across sessions
do
  local s = require("config.state").load()
  if s.minipairs_disable ~= nil then vim.g.minipairs_disable = s.minipairs_disable end
end

vim.keymap.set("n", "<leader>up", function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  local st = require("config.state")
  local s = st.load()
  s.minipairs_disable = vim.g.minipairs_disable
  st.save(s)
  vim.notify("Auto pairs: " .. (vim.g.minipairs_disable and "OFF" or "ON"), vim.log.levels.INFO, { title = "Editor" })
end, { desc = "Toggle auto pairs" })

-- Send current /search pattern to quickfix list
vim.keymap.set("n", "<leader>sq", function()
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
