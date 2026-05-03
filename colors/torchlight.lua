require("torchlight").setup({ contrast = "medium" })
local function strip_italic(group)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl then hl.italic = false; vim.api.nvim_set_hl(0, group, hl) end
end
strip_italic("Comment")
strip_italic("String")
