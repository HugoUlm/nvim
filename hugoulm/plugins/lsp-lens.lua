local SymbolKind = vim.lsp.protocol.SymbolKind

return {
	"VidocqH/lsp-lens.nvim",
	opts = {
		enable = true,
		include_declaration = false,
		sections = {
			references = true,
		},
		target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
		wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
	},
}
