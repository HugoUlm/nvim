local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local my_utils = require("hugoulm.plugins.heirline.utils")

local function map_to_names(client_list)
	return vim.tbl_map(function(client) return client.name end, client_list)
end

local Space = { provider = " " }
local Align = { provider = "%=" }

local default_bg = "#252d39"

local Mode = {
	static = {
		modes = {
			n = { "NORMAL", "ErrorMsg" },
			no = { "NORMAL?", "ModeOperator" },
			v = { "VISUAL", "ModeVisual" },
			V = { "VISUAL-L", "ModeVisual" },
			[""] = { "VISUAL-B", "ModeVisual" },
			s = { "SELECT", "ModeVisual" },
			S = { "SELECT-L", "ModeVisual" },
			[""] = { "SELECT-B", "ModeVisual" },
			i = { "INSERT", "WarningMsg" },
			R = { "REPLACE", "ModeReplace" },
			c = { "COMMAND", "ModeCommand" },
			["!"] = { "SHELL", "ModeCommand" },
			r = { "PROMPT", "ModePrompt" },
			t = { "TERMINAL", "ModeTerminal" },
		},
	},
	init = function(self)
		local short_mode = vim.fn.mode(1) or "n"
		local mode = self.modes[short_mode:sub(1, 2)] or self.modes[short_mode:sub(1, 1)] or
		    { "UNKNOWN", "ModeNormal" }
		local hl = my_utils.hl(mode[2])

		self[1] = self:new(
			my_utils.build_pill(
				{},
				{ provider = " ", hl = { fg = my_utils.palette().base, bg = hl.fg } },
				{ { provider = " " .. mode[1], hl = hl } },
				"provider"
			),
			1
		)
	end,
	update = { "ModeChanged" },
	provider = " ",
	hl = { bold = true },
}

local Git = {
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict
		    and (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)

		self[1] = self:new(
			my_utils.build_pill(
				{},
				{ provider = vim.fn.nr2char(0xF09B) .. " ", hl = { fg = my_utils.palette().base, bg = utils.get_highlight("@variable.parameter").fg } },
				{ { provider = " " .. self.head, hl = { fg = utils.get_highlight("@variable.parameter").fg, bg = my_utils.darken(utils.get_highlight("@variable.parameter").fg, 0.3) } } },
				"provider"
			),
			1
		)
	end,
	condition = function(self)
		self.head = vim.fn.FugitiveHead()
		return type(self.head) == "string"
	end,
}

local FileName = {
	flexible = 2,
	init = function(self)
		self.relname = vim.fn.fnamemodify(self.filename, ":.")
		local ext = vim.fn.fnamemodify(self.filename, ":e")
		if self.relname == "" then
			self.relname = "[No Name]"
		end
		self.icon, self.color = require("nvim-web-devicons").get_icon_color(self.filename, ext,
			{ default = true })
	end,
	{
		provider = function(self)
			return self.relname
		end,
	},
	{
		provider = function(self)
			return vim.fn.pathshorten(self.relname)
		end,
	},
	{
		provider = function(self)
			return vim.fn.fnamemodify(self.filename, ":t")
		end,
	},
	hl = function(self)
		return { bg = default_bg, fg = self.color, bold = true }
	end,
}


local get_filename = function()
	local full_path = vim.api.nvim_buf_get_name(0)
	local home = vim.fn.expand("~")
	local short_path = full_path:gsub("^" .. vim.pesc(home), "~")

	-- Split the path into parts
	local parts = {}
	for part in short_path:gmatch("[^/]+") do
		table.insert(parts, part)
	end

	-- Get the last 3 parts (2 folders + filename)
	local start_index = math.max(#parts - 2, 1)
	local last_parts = {}
	for i = start_index, #parts do
		table.insert(last_parts, parts[i])
	end

	return "~/" .. table.concat(last_parts, "/")
end

local FileNameBlock = {
	update = { "BufEnter", "DirChanged", "BufModifiedSet", "VimResized" },
	init = function(self)
		local short_path = get_filename()
		self.filename = vim.api.nvim_buf_get_name(0)
		local ext = vim.fn.fnamemodify(self.filename, ":e")

		self[1] = self:new(
			my_utils.build_icon_pill(
				short_path,
				ext
			),
			1
		)
	end,
}


local Diagnostics = {
	static = {
		error_icon = " ",
		warn_icon = "",
		info_icon = "",
		hint_icon = "",
	},
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,
	update = { "DiagnosticChanged", "BufEnter" },
	{
		provider = function(self)
			return self.errors > 0 and string.format(" %s:%s", self.error_icon, self.errors)
		end,
		hl = { fg = "red_fg", bold = true },
	},
	{
		provider = function(self)
			return self.warnings > 0 and string.format(" %s:%s", self.warn_icon, self.warnings)
		end,
		hl = { fg = "yellow_fg", bold = true },
	},
	{
		provider = function(self)
			return self.info > 0 and string.format(" %s:%s", self.info_icon, self.info)
		end,
		hl = { fg = "green_fg", bold = true },
	},
	{
		provider = function(self)
			return self.hints > 0 and string.format(" %s:%s", self.hint_icon, self.hints)
		end,
		hl = { fg = "magenta_fg", bold = true },
	},
}


local LSP = {
	condition = function(self)
		self.active_clients = vim.lsp.get_clients()
		return not vim.tbl_isempty(self.active_clients)
	end,

	update = { "LspAttach", "LspDetach", "BufEnter", "DiagnosticChanged" },

	init = function(self)
		local servers = {}
		local active_clients = map_to_names(self.active_clients)
		local buffer_clients = map_to_names(vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() })
		local counted_clients = {}

		for _, client in ipairs(active_clients) do
			counted_clients[client] = (counted_clients[client] or 0) + 1
		end

		for client, count in pairs(counted_clients) do
			local text = client
			if count > 1 then
				text = text .. " ×" .. count
			end
			text = text .. " "

			table.insert(servers, {
				provider = text,
				hl = vim.tbl_contains(buffer_clients, client) and
				    my_utils.hl_override().CustomTablineLspActive
				    or my_utils.hl_override().CustomTablineLspInactive,
				lite = true,
			})
		end

		table.insert(servers, {
			provider = "%7(%l/%3L%):%2c ",
			hl = my_utils.hl_override().CustomTablineLspActive,
			lite = true,
		})

		self[1] = self:new(
			my_utils.build_pill(servers,
				{ provider = vim.fn.nr2char(0xF085) .. " ", hl = my_utils.hl_override().CustomTablineLsp, lite = true },
				{ provider = " ", hl = my_utils.hl_override().CustomTablineLsp, lite = true },
				"provider"
			),
			1
		)
		self[2] = self:new({ provider = " " }, 2)
	end,
}

local DefaultStatusLine = {
	Mode,
	Space,
	Git,
	Space,
	FileNameBlock,
	Align,
	Diagnostics,
	Space,
	LSP,
	hl = { bg = default_bg, bold = true },
}

local InactiveStatusline = {
	condition = conditions.is_not_active,
	Align,
	{
		init = function(self)
			self.filename = vim.api.nvim_buf_get_name(0)
		end,
		FileName,
	},
	Align,
}

local TerminalName = {
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return " " .. tname
	end,
	hl = { bold = true },
}

local TerminalStatusline = {
	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,
	{ condition = conditions.is_active, Mode, Space },
	Align,
	TerminalName,
	Align,
}

return {
	hl = function()
		if conditions.is_active() then
			return "StatusLine"
		else
			return "StatusLineNC"
		end
	end,
	fallthrough = false,
	TerminalStatusline,
	InactiveStatusline,
	DefaultStatusLine,
}
