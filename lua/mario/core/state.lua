local M = {}
local path = vim.fn.stdpath("data") .. "/mario_ui_toggles.json"

function M.load()
    local ok, lines = pcall(vim.fn.readfile, path)
    if ok and lines and #lines > 0 then
        local ok2, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
        if ok2 and type(decoded) == "table" then return decoded end
    end
    return {}
end

function M.save(tbl)
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    pcall(vim.fn.writefile, { vim.fn.json_encode(tbl) }, path)
end

function M.get(key, default)
    local value = M.load()[key]
    if value == nil then
        return default
    end
    return value
end

function M.set(key, value)
    local values = M.load()
    values[key] = value
    M.save(values)
end

return M
