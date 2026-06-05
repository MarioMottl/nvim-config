local bg0    = "#181a1b"
local bg1    = "#34373a"
local bg2    = "#181a1b"
local fg     = "#c8c8c8"
local fg_dim = "#9da1a3"
local yellow = "#FAC03B"

return {
	normal  = { a = { bg = yellow,    fg = bg0, gui = "bold" }, b = { bg = bg1, fg = fg }, c = { bg = bg2, fg = fg_dim } },
	insert  = { a = { bg = "#a3db81", fg = bg0, gui = "bold" }, b = { bg = bg1, fg = fg }, c = { bg = bg2, fg = fg_dim } },
	visual  = { a = { bg = "#a29bfe", fg = bg0, gui = "bold" }, b = { bg = bg1, fg = fg }, c = { bg = bg2, fg = fg_dim } },
	replace = { a = { bg = "#c15959", fg = fg,  gui = "bold" }, b = { bg = bg1, fg = fg }, c = { bg = bg2, fg = fg_dim } },
	command = { a = { bg = "#a1e0ea", fg = bg0, gui = "bold" }, b = { bg = bg1, fg = fg }, c = { bg = bg2, fg = fg_dim } },
	inactive = {
		a = { bg = bg2, fg = fg_dim },
		b = { bg = bg2, fg = fg_dim },
		c = { bg = bg2, fg = fg_dim },
	},
}
