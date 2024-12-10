return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git" })
		vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<CR>", { desc = "Git add all" })
		vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
		vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
		vim.keymap.set("n", "<leader>gp", function()
			vim.cmd.Git("yeet")
		end, { desc = "Git yeet" })
		-- rebase always
		vim.keymap.set("n", "<leader>gP", function()
			vim.cmd.Git({ "pull", "--rebase" })
		end, { desc = "Git pull with rebase" })
		-- NOTE: It allows me to easily set the branch i am pushing and any tracking
		-- needed if i did not set the branch up correctly
		vim.keymap.set("n", "<leader>gpo", ":Git push -u origin ", { desc = "Git push origin" })
		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
	end,
}
