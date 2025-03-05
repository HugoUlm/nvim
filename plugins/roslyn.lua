return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	opts = {},
	config = function()
		require("roslyn").setup({})

		local map = function(mode, lhs, rhs, opts)
			local options = { noremap = true, silent = true }
			if opts then
				options = vim.tbl_extend("force", options, opts)
			end
			vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
		end

		map("n", "gd", ':lua require("telescope.builtin").lsp_definitions()<CR>', { desc = "[G]oto [D]efinition" })
		map("n", "gr", ':lua require("telescope.builtin").lsp_references()<CR>', { desc = "[G]oto [R]eferences" })
		map(
			"n",
			"gI",
			':lua require("telescope.builtin").lsp_implementations()<CR>',
			{ desc = "[G]oto [I]mplementation" }
		)
		map(
			"n",
			"<leader>D",
			':lua require("telescope.builtin").lsp_type_definitions()<CR>',
			{ desc = "Type [D]efinition" }
		)
		map(
			"n",
			"<leader>ds",
			':lua require("telescope.builtin").lsp_document_symbols()<CR>',
			{ desc = "[D]ocument [S]ymbols" }
		)
		map(
			"n",
			"<leader>ws",
			':lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>',
			{ desc = "[W]orkspace [S]ymbols" }
		)
		map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { desc = "[R]e[n]ame" })
		map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { desc = "[C]ode [A]ction" })
		map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", { desc = "[G]oto [D]eclaration" })
	end,
	requires = { "nvim-lua/plenary.nvim" },
}
