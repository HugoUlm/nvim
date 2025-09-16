return {
	"iabdelkareem/csharp.nvim",
	dependencies = {
		"williamboman/mason.nvim", -- Automatically installs omnisharp
		"mfussenegger/nvim-dap", -- Debug adapter
		"Tastyep/structlog.nvim", -- Optional but useful for debugging plugin issues
	},
	config = function()
		-- Only run if mason wasn't initialized elsewhere
		require("mason").setup()

		require("csharp").setup({
			lsp = {
				omnisharp = {
					enable = true,
					enable_editor_config_support = true,
					organize_imports = true,
					enable_analyzers_support = true,
					enable_import_completion = true,
					analyze_open_documents_only = false,
					enable_package_auto_restore = true,
				},
			},
		})
	end,
}
