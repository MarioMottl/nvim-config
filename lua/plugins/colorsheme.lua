local active_theme = "sitruuna"

-- kanso variants: "zen", "ink", "mist", "pearl"
local kanso_variant = "zen"

if active_theme == "kanso" then
    return {
        {
            "webhooked/kanso.nvim",
            name = "kanso",
            lazy = false,
            priority = 1000,
            config = function()
                require("kanso").setup({
                    theme = kanso_variant,
                })
                vim.cmd("colorscheme kanso-" .. kanso_variant)
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "kanso-" .. kanso_variant,
            },
        },
    }
elseif active_theme == "naysayer" then
    return {
        {
            "RostislavArts/naysayer.nvim",
            name = "naysayer",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd("colorscheme naysayer")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "naysayer",
            },
        },
    }
elseif active_theme == "gruvbox" then
    return {
        {
            "ellisonleao/gruvbox.nvim",
            name = "gruvbox",
            lazy = false,
            priority = 1000,
            opts = {
                contrast = "medium",
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            },
            config = function(_, opts)
                vim.o.background = "dark"
                require("gruvbox").setup(opts)
                vim.cmd("colorscheme gruvbox")
                vim.api.nvim_set_hl(0, "Cursor", { fg = "#282828", bg = "#fabd2f" })
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "gruvbox",
            },
        },
    }
elseif active_theme == "gruvbox-hard" then
    return {
        {
            "ellisonleao/gruvbox.nvim",
            name = "gruvbox",
            lazy = false,
            priority = 1000,
            opts = {
                contrast = "hard",
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            },
            config = function(_, opts)
                vim.o.background = "dark"
                require("gruvbox").setup(opts)
                vim.cmd("colorscheme gruvbox")
                vim.api.nvim_set_hl(0, "Cursor", { fg = "#1d2021", bg = "#fabd2f" })
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "gruvbox",
            },
        },
    }
elseif active_theme == "miasma" then
    return {
        {
            "xero/miasma.nvim",
            name = "miasma",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd("colorscheme miasma")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "miasma",
            },
        },
    }
elseif active_theme == "kanagawa-wave" then
    return {
        {
            "rebelot/kanagawa.nvim",
            name = "kanagawa",
            lazy = false,
            priority = 1000,
            config = function()
                require("kanagawa").setup({ theme = "wave" })
                vim.cmd("colorscheme kanagawa-wave")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "kanagawa-wave",
            },
        },
    }
elseif active_theme == "kanagawa-dragon" then
    return {
        {
            "rebelot/kanagawa.nvim",
            name = "kanagawa",
            lazy = false,
            priority = 1000,
            config = function()
                require("kanagawa").setup({ theme = "dragon" })
                vim.cmd("colorscheme kanagawa-dragon")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "kanagawa-dragon",
            },
        },
    }
elseif active_theme == "melange" then
    return {
        {
            "savq/melange-nvim",
            name = "melange",
            lazy = false,
            priority = 1000,
            config = function()
                vim.o.background = "dark"
                vim.cmd("colorscheme melange")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "melange",
            },
        },
    }
elseif active_theme == "fleury" then
    -- local colorscheme, no plugin needed (colors/fleury.lua)
    return {
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "fleury",
            },
        },
    }
elseif active_theme == "thorn" then
    return {
        {
            "jpwol/thorn.nvim",
            branch = "refactor/theme-change",
            name = "thorn",
            lazy = false,
            priority = 1000,
            config = function()
                require("thorn").setup()
                vim.cmd("colorscheme thorn-forest")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "thorn-forest",
            },
        },
    }
elseif active_theme == "catppuccin-mocha" then
    return {
        {
            "catppuccin/nvim",
            name = "catppuccin",
            lazy = false,
            priority = 1000,
            config = function()
                require("catppuccin").setup({ flavour = "mocha" })
                vim.cmd("colorscheme catppuccin-mocha")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "catppuccin-mocha",
            },
        },
    }
elseif active_theme == "poimandres" then
    return {
        {
            "olivercederborg/poimandres.nvim",
            name = "poimandres",
            lazy = false,
            priority = 1000,
            config = function()
                require("poimandres").setup({})
                vim.cmd("colorscheme poimandres")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "poimandres",
            },
        },
    }
elseif active_theme == "adwaita" then
    return {
        {
            "Mofiqul/adwaita.nvim",
            name = "adwaita",
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.adwaita_darker = false
                vim.o.background = "dark"
                vim.cmd("colorscheme adwaita")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "adwaita",
            },
        },
    }
elseif active_theme == "adwaita-darker" then
    return {
        {
            "Mofiqul/adwaita.nvim",
            name = "adwaita",
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.adwaita_darker = true
                vim.o.background = "dark"
                vim.cmd("colorscheme adwaita")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "adwaita",
            },
        },
    }
elseif active_theme == "torchlight" then
    return {
        {
            "skylarmb/torchlight.nvim",
            name = "torchlight",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd("colorscheme torchlight")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "torchlight",
            },
        },
    }
elseif active_theme == "neodarcula" then
    return {
        {
            "pmouraguedes/neodarcula.nvim",
            name = "neodarcula",
            lazy = false,
            priority = 1000,
            config = function()
                require("neodarcula").setup({})
                vim.cmd("colorscheme neodarcula")
                local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Comment", link = false })
                if ok and hl then
                    hl.italic = false
                    vim.api.nvim_set_hl(0, "Comment", hl)
                end
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "neodarcula",
            },
        },
    }
elseif active_theme == "sitruuna" then
    return {
        {
            "haze/sitruuna.vim",
            name = "sitruuna",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd("colorscheme sitruuna")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "sitruuna",
            },
        },
    }
elseif active_theme == "kanagawa-paper-ink" then
    return {
        {
            "thesimonho/kanagawa-paper.nvim",
            name = "kanagawa-paper",
            lazy = false,
            priority = 1000,
            config = function()
                require("kanagawa-paper").setup({ theme = "ink" })
                vim.cmd("colorscheme kanagawa-paper-ink")
            end,
        },
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "kanagawa-paper-ink",
            },
        },
    }
else
    error("Unknown theme: " .. active_theme)
end
