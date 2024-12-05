return {
	-- Sync clipboard between OS and Neovim.
	vim.schedule(function()
		vim.opt.clipboard = "unnamedplus"
	end)
}
