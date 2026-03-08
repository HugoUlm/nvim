local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local my_utils = require("hugoulm.plugins.heirline.utils")

local function map_to_names(client_list)
	return vim.tbl_map(function(client) return client.name end, client_list)
end

local Space = { provider = " " }
local Align = { provider = "%=" }

local default_bg = my_utils.palette().mantle

local mode_table = {
	n = { "NORMAL", "ModeNormal" },
	no = { "NORMAL?", "ModeOperator" },
	v = { "VISUAL", "ModeVisual" },
	V = { "VISUAL-L", "ModeVisual" },
	["\x16"] = { "VISUAL-B", "ModeVisual" },
	s = { "SELECT", "ModeVisual" },
	S = { "SELECT-L", "ModeVisual" },
	["\x13"] = { "SELECT-B", "ModeVisual" },
	i = { "INSERT", "ModeInsert" },
	R = { "REPLACE", "ModeReplace" },
	c = { "COMMAND", "ModeCommand" },
	["!"] = { "SHELL", "ModeCommand" },
	r = { "PROMPT", "ModePrompt" },
	t = { "TERMINAL", "ModeTerminal" },
}

local get_filename = function()
	local full_path = vim.api.nvim_buf_get_name(0)
	local home = vim.fn.expand("~")
	local short_path = full_path:gsub("^" .. vim.pesc(home), "~")

	local parts = {}
	for part in short_path:gmatch("[^/]+") do
		table.insert(parts, part)
	end

	local start_index = math.max(#parts - 2, 1)
	local last_parts = {}
	for i = start_index, #parts do
		table.insert(last_parts, parts[i])
	end

	return "~/" .. table.concat(last_parts, "/")
end

-- Combined Mode + Git + File pill, styled like the LSP pill:
-- all segments are left-items; same-color sub-items use lite (thin) dividers,
-- color-change transitions use full arrows.
local ModeGitFile = {
	update = { "ModeChanged", "BufEnter", "DirChanged", "BufModifiedSet", "VimResized" },
	init = function(self)
		-- Mode
		local short_mode = vim.fn.mode(1) or "n"
		local mode = mode_table[short_mode:sub(1, 2)] or mode_table[short_mode:sub(1, 1)] or
		    { "UNKNOWN", "ModeNormal" }
		local mode_hl = my_utils.hl(mode[2])
		local mode_icon_hl = { fg = my_utils.palette().base, bg = mode_hl.fg }

		-- File
		local fname = vim.api.nvim_buf_get_name(0)
		local ext = vim.fn.fnamemodify(fname, ":e")
		local short_path = get_filename()
		local devicons = require("nvim-web-devicons")
		local file_icon = devicons.get_icon(short_path, ext, { default = true })
		if not file_icon then file_icon = "" end
		local file_icon_bg = my_utils.get_icon_color(fname, ext)
		local file_text_bg = my_utils.darken(file_icon_bg, 0.3)
		local file_icon_hl = { fg = my_utils.palette().base, bg = file_icon_bg }
		local file_text_hl = { fg = file_icon_bg, bg = file_text_bg }

		local items = {}

		-- Mode icon (i=1, always full arrow)
		table.insert(items, { provider = " ", hl = mode_icon_hl })
		-- Mode text (full arrow transition from bright icon to dark text)
		table.insert(items, { provider = " " .. mode[1] .. " ", hl = mode_hl })

		-- Git (full color-change arrow from mode, then thin divider for text)
		local git_head = vim.fn.FugitiveHead()
		if type(git_head) == "string" and git_head ~= "" then
			local git_bg_raw = utils.get_highlight("@variable.parameter").fg
			local git_icon_bg = type(git_bg_raw) == "number" and string.format("#%06x", git_bg_raw) or git_bg_raw
			local git_text_bg = my_utils.darken(git_icon_bg, 0.3)
			table.insert(items, { provider = vim.fn.nr2char(0xF09B) .. " ", hl = { fg = my_utils.palette().base, bg = git_icon_bg } })
			table.insert(items, { provider = " " .. git_head .. " ", hl = { fg = git_icon_bg, bg = git_text_bg } })
		end

		-- File icon (full color-change arrow from git/mode, then thin divider for text)
		table.insert(items, { provider = file_icon .. " ", hl = file_icon_hl })
		table.insert(items, { provider = " " .. short_path .. " ", hl = file_text_hl })

		-- Dummy center with same bg as last item so separator is invisible
		local dummy = { provider = "", hl = file_text_hl }

		self[1] = self:new(
			my_utils.build_pill(items, dummy, {}, "provider", { no_start_sep = true }),
			1
		)
	end,
	provider = " ",
	hl = { bold = true },
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
		local lsp_hl = my_utils.hl_override().CustomTablineLsp
		local lsp_active_hl = my_utils.hl_override().CustomTablineLspActive
		local lsp_inactive_hl = my_utils.hl_override().CustomTablineLspInactive

		local active_clients = map_to_names(self.active_clients)
		local buffer_clients = map_to_names(vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() })
		local counted_clients = {}

		for _, client in ipairs(active_clients) do
			counted_clients[client] = (counted_clients[client] or 0) + 1
		end

		-- Gear icon as first item (opening arrow, bright bg)
		local items = {
			{ provider = vim.fn.nr2char(0xF085) .. " ", hl = lsp_hl },
		}

		for client, count in pairs(counted_clients) do
			local text = " " .. client
			if count > 1 then text = text .. " ×" .. count end
			text = text .. " "
			table.insert(items, {
				provider = text,
				hl = vim.tbl_contains(buffer_clients, client) and lsp_active_hl or lsp_inactive_hl,
			})
		end

		-- Row:col as last item before dummy center
		table.insert(items, {
			provider = " %7(%l/%3L%):%2c ",
			hl = lsp_active_hl,
		})

		local dummy = { provider = "", hl = lsp_active_hl }

		self[1] = self:new(
			my_utils.build_pill(items, dummy, {}, "provider", { no_start_sep = true }),
			1
		)
		self[2] = self:new({ provider = " " }, 2)
	end,
}

local DefaultStatusLine = {
	ModeGitFile,
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

local TerminalMode = {
	update = { "ModeChanged" },
	init = function(self)
		local short_mode = vim.fn.mode(1) or "n"
		local mode = mode_table[short_mode:sub(1, 2)] or mode_table[short_mode:sub(1, 1)] or
		    { "UNKNOWN", "ModeNormal" }
		local mode_hl = my_utils.hl(mode[2])
		self[1] = self:new(
			my_utils.build_pill(
				{},
				{ provider = vim.fn.nr2char(0xf36f) .. " ", hl = { fg = my_utils.palette().base, bg = mode_hl.fg } },
				{ { provider = " " .. mode[1], hl = mode_hl } },
				"provider"
			),
			1
		)
	end,
	provider = " ",
	hl = { bold = true },
}

local TerminalStatusline = {
	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,
	{ condition = conditions.is_active, TerminalMode, Space },
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
