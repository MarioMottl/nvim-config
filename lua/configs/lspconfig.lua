require("nvchad.configs.lspconfig").defaults()

local servers = {
    "lua_ls",
    "rust_analyzer",
    "html",
    "cssls",
}

vim.lsp.enable(servers)
