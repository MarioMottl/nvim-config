local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.copyindent = true
opt.preserveindent = true
opt.cmdheight = 0
opt.conceallevel = 0

opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.list = true

opt.foldmethod = "marker"
opt.foldmarker = "#pragma region,#pragma endregion"

 -- don't show "written" message on save
opt.shortmess:append("W")

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local bo = vim.bo[args.buf]
        bo.autoindent = true
        bo.smartindent = true
        bo.copyindent = true
        bo.preserveindent = true
    end,
})
