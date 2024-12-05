local M = {}

---Copy the given component, merging its fields with `with`
---@param block table
---@param with? table
---@return table
function M.clone(block, with)
	return vim.tbl_deep_extend("force", block, with or {})
end

---Surround component with separators and adjust coloring
---@param delimiters string[]
---@param color string|function|nil
---@param component table
---@return table
function M.surround(delimiters, color, component)
	component = M.clone(component)

	local surround_color = function(self)
		if type(color) == "function" then
			return color(self)
		else
			return color
		end
	end

	return {
		{
			hl = function(self)
				local s_color = surround_color(self)
				if s_color then
					return { fg = s_color }
				end
			end,
			provider = delimiters[1],
		},
		{
			hl = function(self)
				local s_color = surround_color(self)
				if s_color then
					return { bg = s_color }
				end
			end,
			component,
		},
		{
			hl = function(self)
				local s_color = surround_color(self)
				if s_color then
					return { fg = s_color }
				end
			end,
			provider = delimiters[2],
		},
	}
end

return M
