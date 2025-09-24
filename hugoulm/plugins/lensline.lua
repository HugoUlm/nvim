return {
	"oribarilan/lensline.nvim",
	event = "LspAttach",
	config = function()
		require("lensline").setup()
	end,
}
