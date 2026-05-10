local M = {}
local path = vim.fn.stdpath("data") .. "/ui_toggles.json"

function M.load()
  local ok, lines = pcall(vim.fn.readfile, path)
  if ok and lines and #lines > 0 then
    local ok2, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
    if ok2 and type(decoded) == "table" then return decoded end
  end
  return {}
end

function M.save(tbl)
  pcall(vim.fn.writefile, { vim.fn.json_encode(tbl) }, path)
end

return M
