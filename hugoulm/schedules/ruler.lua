return {
	-- Schedule set ruler on 80 chars and set color to light pink
	vim.schedule(function()
		local filename = vim.api.nvim_buf_get_name(0)
		if filename == "" then
			return
		end
		vim.cmd(":set cc=80")
		vim.cmd(":hi ColorColumn guibg=#fa75ff")
	end),
}
