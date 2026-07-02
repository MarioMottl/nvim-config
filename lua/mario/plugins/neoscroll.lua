return {
    "karb94/neoscroll.nvim",
    config = function()
        local neoscroll = require("neoscroll")

        neoscroll.setup({
            easing = "quadratic",
            hide_cursor = true,
            stop_eof = true,
        })

        local keymap = {
            ["<C-u>"]    = function() neoscroll.ctrl_u({ duration = 100 }) end,
            ["<C-d>"]    = function() neoscroll.ctrl_d({ duration = 100 }) end,
            ["<C-b>"]    = function() neoscroll.ctrl_b({ duration = 100 }) end,
            ["<C-f>"]    = function() neoscroll.ctrl_f({ duration = 100 }) end,
            ["<PageUp>"] = function() neoscroll.ctrl_b({ duration = 100 }) end,
            ["<PageDown>"] = function() neoscroll.ctrl_f({ duration = 100 }) end,
            ["zt"]       = function() neoscroll.zt({ half_win_duration = 100 }) end,
            ["zz"]       = function() neoscroll.zz({ half_win_duration = 100 }) end,
            ["zb"]       = function() neoscroll.zb({ half_win_duration = 100 }) end,
        }

        for key, fn in pairs(keymap) do
            vim.keymap.set({ "n", "v", "x" }, key, fn)
        end
    end,
}
