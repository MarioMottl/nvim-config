local M = {}

-- Each item: repo, optional name/branch, schemes list
M.items = {
    {
        repo = "haze/sitruuna.vim",
        name = "sitruuna",
        schemes = { "sitruuna" },
    },
    {
        repo = "webhooked/kanso.nvim",
        name = "kanso",
        schemes = { "kanso-zen", "kanso-ink", "kanso-mist", "kanso-pearl" },
    },
    {
        repo = "RostislavArts/naysayer.nvim",
        name = "naysayer",
        schemes = { "naysayer" },
    },
    {
        repo = "ellisonleao/gruvbox.nvim",
        schemes = { "gruvbox" },
    },
    {
        repo = "rebelot/kanagawa.nvim",
        schemes = { "kanagawa", "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
    },
    {
        repo = "thesimonho/kanagawa-paper.nvim",
        name = "kanagawa-paper",
        schemes = { "kanagawa-paper-ink", "kanagawa-paper-canvas" },
    },
    {
        repo = "xero/miasma.nvim",
        name = "miasma",
        schemes = { "miasma" },
    },
    {
        repo = "savq/melange-nvim",
        name = "melange",
        schemes = { "melange" },
    },
    {
        repo = "jpwol/thorn.nvim",
        branch = "refactor/theme-change",
        name = "thorn",
        schemes = { "thorn-forest" },
    },
    {
        repo = "catppuccin/nvim",
        name = "catppuccin",
        schemes = { "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha" },
    },
    {
        repo = "olivercederborg/poimandres.nvim",
        name = "poimandres",
        schemes = { "poimandres" },
    },
    {
        repo = "Mofiqul/adwaita.nvim",
        name = "adwaita",
        schemes = { "adwaita" },
    },
    {
        repo = "skylarmb/torchlight.nvim",
        name = "torchlight",
        schemes = { "torchlight" },
    },
    {
        repo = "pmouraguedes/neodarcula.nvim",
        name = "neodarcula",
        schemes = { "neodarcula" },
    },
    {
        repo = "folke/tokyonight.nvim",
        schemes = { "tokyonight-night", "tokyonight-storm", "tokyonight-day", "tokyonight-moon" },
    },
    {
        repo = "rose-pine/neovim",
        name = "rose-pine",
        schemes = { "rose-pine", "rose-pine-main", "rose-pine-moon", "rose-pine-dawn" },
    },
    {
        repo = "shaunsingh/nord.nvim",
        schemes = { "nord" },
    },
    {
        repo = "navarasu/onedark.nvim",
        schemes = { "onedark" },
    },
    {
        repo = "EdenEast/nightfox.nvim",
        schemes = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" },
    },
    {
        repo = "sainnhe/everforest",
        schemes = { "everforest" },
    },
    {
        repo = "sainnhe/sonokai",
        schemes = { "sonokai" },
    },
    {
        repo = "Mofiqul/dracula.nvim",
        schemes = { "dracula", "dracula-soft" },
    },
    {
        repo = "nyoom-engineering/oxocarbon.nvim",
        schemes = { "oxocarbon" },
    },
}

function M.names()
    local names = {}
    for _, item in ipairs(M.items) do
        vim.list_extend(names, item.schemes)
    end
    return names
end

return M
