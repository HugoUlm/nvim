local M = {}

function M.invertHex(hex)
	-- Remove the leading '#' if present
	if hex:sub(1, 1) == "#" then
		hex = hex:sub(2)
	end

	-- Convert 3-digit hex to 6-digit hex
	if #hex == 3 then
		hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
	end

	-- Validate hex length
	if #hex ~= 6 then
		error(string.format("[%s] is an invalid hex color", hex))
	end

	-- Invert color components
	local function invertComponent(component)
		local value = 255 - tonumber(component, 16)
		return string.format("%02x", value)
	end

	local r = invertComponent(hex:sub(1, 2))
	local g = invertComponent(hex:sub(3, 4))
	local b = invertComponent(hex:sub(5, 6))

	-- Return the inverted color with leading '#'
	return "#" .. r .. g .. b
end

function M.getFilenameColor()
	local color = ""
	function GetColor(self)
		local filename = self.filename
		local ext = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, ext, { default = true })
		color = self.icon_color
	end
	return color
end

return M
