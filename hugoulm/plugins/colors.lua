local utils = require("hugoulm.plugins.heirline.utils")

return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 10000,
	opts = {
		flavour = "mocha",
		term_colors = true,
		integrations = {
			blink_cmp = true,
			neotest = true,
			noice = true,
			diffview = true,
			gitsigns = true,
			snacks = { enabled = true },
			lsp_trouble = true,
			which_key = true,
		},
		lsp_styles = {
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
				ok = { "underline" },
			},
		},
		compile = {
			enabled = true,
		},
		highlight_overrides = {
			all = utils.hl_override
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
