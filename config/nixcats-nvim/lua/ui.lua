require("tokyonight").setup({
	style = "storm",
	transparent = true,

	on_highlights = function(hl, c)
		hl.LineNr = {
			fg = "#5e8ed1",
		}

		hl.LineNrAbove = {
			fg = "#5e8ed1",
		}

		hl.LineNrBelow = {
			fg = "#5e8ed1",
		}

		hl.CursorLineNr = {
			fg = "#89ddff",
			bold = true,
		}

		hl.CursorLine = {
			bg = "NONE",
		}
	end,
})

vim.cmd.colorscheme("tokyonight-storm")

require("lualine").setup({
	options = {
		theme = "tokyonight",
		component_separators = "|",
		section_separators = " ",
	},
})

require("gitsigns").setup()
require("Comment").setup()
require("zen-mode").setup()
require("which-key").setup()
