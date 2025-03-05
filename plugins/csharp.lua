return {
	"iabdelkareem/csharp.nvim",
	dependencies = {
		"williamboman/mason.nvim", -- Required, automatically installs omnisharp
		"mfussenegger/nvim-dap",
		"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
	},
	config = function()
		require("mason").setup() -- Mason setup must run before csharp, only if you want to use omnisharp
		require("csharp").setup()
	end,
	opts = {
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
	},
}
