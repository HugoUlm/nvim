return {
	dir = vim.fn.stdpath("config"),
	name = "prompt",
	lazy = false,
	priority = 10000,
	config = function()
		vim.cmd.colorscheme("prompt")
	end,
}