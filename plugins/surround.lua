return {
	"echasnovski/mini.surround",
	recommended = true,
	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			replace = "sr",
		},
	},
	keys = function(_, keys)
		local mappings = {
			{ "sa", desc = "Add Surrounding", mode = { "n", "v" } },
			{ "sd", desc = "Delete Surrounding" },
			{ "sr", desc = "Replace Surrounding" },
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
}
