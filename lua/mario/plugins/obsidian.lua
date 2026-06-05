return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	cmd = { "Obsidian" },
	keys = {
		{ "<leader>ob", "<cmd>Obsidian backlinks<CR>",    desc = "Obsidian backlinks" },
		{ "<leader>od", "<cmd>Obsidian today<CR>",        desc = "Obsidian daily note" },
		{ "<leader>ol", "<cmd>Obsidian links<CR>",        desc = "Obsidian note links" },
		{ "<leader>oo", "<cmd>Obsidian open<CR>",         desc = "Open in Obsidian" },
		{ "<leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian quick switch" },
		{ "<leader>os", "<cmd>Obsidian search<CR>",       desc = "Search Obsidian notes" },
		{ "<leader>ot", "<cmd>Obsidian template<CR>",     desc = "Insert template" },
		{ "<leader>oT", "<cmd>Obsidian toc<CR>",          desc = "Obsidian TOC" },
		{ "<leader>on", "<cmd>Obsidian new<CR>",          desc = "New note" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	init = function()
		local group = vim.api.nvim_create_augroup("MarioObsidianMarkdown", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "markdown",
			callback = function(args)
				require("mario.core.obsidian").setup_markdown_buffer(args.buf)
			end,
		})
	end,
	opts = function()
		return require("mario.core.obsidian").opts()
	end,
	config = function(_, opts)
		require("obsidian").setup(opts)
		require("mario.core.obsidian").patch_template_substitutions()
	end,
}
