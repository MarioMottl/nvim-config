return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local bufferline = require("bufferline")

        local function hl(name)
            return vim.api.nvim_get_hl(0, { name = name, link = false })
        end
        local function fg_or_nil(group)
            local v = hl(group)
            return v and v.fg or nil
        end

        local function sync_fill()
            local tf  = hl("TabLineFill")
            local tl  = hl("TabLine")
            local n   = hl("Normal")
            local bg  = (tf and tf.bg) or (tl and tl.bg) or (n and n.bg)
            if bg then vim.api.nvim_set_hl(0, "BufferLineFill", { bg = bg }) end
        end

        local function sync_tabs()
            local n   = hl("Normal")
            local tl  = hl("TabLine")
            local tls = hl("TabLineSel")
            if not n then return end
            local base_bg  = (tl  and tl.bg)  or n.bg
            local base_fg  = (tl  and tl.fg)  or n.fg
            local sel_bg   = (tls and tls.bg)  or n.bg or base_bg
            local sel_fg   = (tls and tls.fg)  or n.fg
            vim.api.nvim_set_hl(0, "BufferLineBackground",       { bg = base_bg, fg = base_fg })
            vim.api.nvim_set_hl(0, "BufferLineBufferVisible",    { bg = base_bg, fg = base_fg })
            vim.api.nvim_set_hl(0, "BufferLineBufferSelected",   { bg = sel_bg,  fg = sel_fg, bold = true })
            vim.api.nvim_set_hl(0, "BufferLineSeparator",        { bg = base_bg, fg = base_bg })
            vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { bg = base_bg, fg = base_bg })
            vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected",{ bg = sel_bg,  fg = sel_bg })
            vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected",{ bg = sel_bg,  fg = fg_or_nil("Special") or sel_fg })
            vim.api.nvim_set_hl(0, "BufferLineModified",         { bg = base_bg, fg = fg_or_nil("DiagnosticWarn") or base_fg })
            vim.api.nvim_set_hl(0, "BufferLineModifiedVisible",  { bg = base_bg, fg = fg_or_nil("DiagnosticWarn") or base_fg })
            vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bg = sel_bg,  fg = fg_or_nil("DiagnosticWarn") or sel_fg })
        end

        local options = {
            options = {
                mode = "buffers",
                separator_style = "thin",
                always_show_bufferline = true,
                sort_by = "insert_after_current",
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
        }

        bufferline.setup(options)
        sync_fill()
        sync_tabs()

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("MarioBufferlineSync", { clear = true }),
            callback = function()
                bufferline.setup(options)
                sync_fill()
                sync_tabs()
            end,
        })
    end,
}
