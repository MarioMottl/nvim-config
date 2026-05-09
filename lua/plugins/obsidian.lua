return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    event = {
        "BufReadPre *.md",
        "BufNewFile *.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "northern-lights",
                path = "~/Northern.Lights",
            },
        },
        daily_notes = {
            folder = "Daily",
            template = "Templates/Daily Note.md",
            date_format = "%Y-%m-%d",
        },
        templates = {
            folder = "Templates",
        },
        completion = {
            nvim_cmp = false,
            min_chars = 2,
            blink = { enabled = true },
        },
        picker = {
            name = "telescope.nvim",
        },
        ui = {
            enable = true,
        },
    },
}
