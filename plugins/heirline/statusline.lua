local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local helper = require("hugoulm.plugins.heirline.helper")

local Space = { provider = " " }
local Align = { provider = "%=" }

local default_bg = "#252d39"

local ViMode = {
	static = {
		modes = {
			n = { "Normal", "N", { "ErrorMsg" } },
			niI = { "Normal", "N" },
			niR = { "Normal", "N" },
			niV = { "Normal", "N" },
			no = { "N·OpPd", "?" },
			v = { "Visual", "V", { "Directory" } },
			V = { "V·Line", "Vl", { "Directory" } },
			[""] = { "V·Blck", "Vb", { "Directory" } },
			s = { "Select", "S", { "Search" } },
			S = { "S·Line", "Sl", { "Search" } },
			[""] = { "S·Block", "Sb", { "Search" } },
			i = { "Insert", "I", { "String" } },
			ic = { "ICompl", "Ic", { "ErrorMsg" } },
			R = { "Rplace", "R", { "WarningMsg", "IncSearch" } },
			Rv = { "VRplce", "Rv", { "WarningMsg", "IncSearch" } },
			c = { "Command", "C", { "Keyword" } },
			cv = { "Vim Ex", "E" },
			ce = { "Ex (r)", "E" },
			r = { "Prompt", "P" },
			rm = { "More  ", "M" },
			["r?"] = { "Cnfirm", "Cn" },
			["!"] = { "Shell ", "S", { "DiffAdd", "diffAdded" } },
			nt = { "Term  ", "T", { "Visual" } },
			t = { "Term  ", "T", { "Visual" } },
			-- t      = { "Term  ", "T", { "DiffAdd", "diffAdded" } },
		},
	},
	init = function(self)
		self.mode = vim.api.nvim_get_mode().mode
	end,
	provider = function(self)
		return "  %2(" .. string.upper(self.modes[self.mode][1]) .. " %)"
	end,
	hl = function(self)
		local hls = self.modes[self.mode][3]
		for _, h in ipairs(hls or {}) do
			local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = h, link = true })
			if ok and type(def) == "table" and (def.fg or def.bg or def.link) then
				return { fg = "black", bg = def.fg, bold = true }
			end
		end
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local Git = {
	init = function(self)
		-- gitsigns buffer changes
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict
			and (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
	end,
	condition = function(self)
		-- priotize gitsigns, otherwise try vim-fugitive
		self.head = vim.b.gitsigns_head
		if not self.head and vim.g.loaded_fugitive == 1 then
			self.head = vim.fn.FugitiveHead()
		end
		return type(self.head) == "string"
	end,
	hl = { bg = utils.get_highlight("@variable.parameter").fg },
	{ -- git branch name
		provider = function(self)
			return "  " .. self.head
		end,
		hl = { fg = "black", bold = true },
	},
	Space,
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "(",
		hl = { bold = true },
	},
	{
		provider = function(self)
			local count = self.status_dict and self.status_dict.added or 0
			return count > 0 and ("+" .. count)
		end,
		hl = { fg = "black" },
	},
	Space,
	{
		provider = function(self)
			local count = self.status_dict and self.status_dict.removed or 0
			return count > 0 and ("-" .. count)
		end,
		hl = { fg = "black" },
	},
	Space,
	{
		provider = function(self)
			local count = self.status_dict and self.status_dict.changed or 0
			return count > 0 and ("~" .. count)
		end,
		hl = { fg = "black" },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = ")",
		hl = { bold = true },
	},
	Space,
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local ext = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, ext, { default = true })
	end,
	provider = function(self)
		return self.icon and (" " .. self.icon .. " ")
	end,
	hl = function(self)
		return { bg = self.icon_color, fg = helper.invertHex(self.icon_color) }
	end,
}

local FileName = {
	-- flexible: shorten path if space doesn't allow for full path
	flexible = 2,
	init = function(self)
		-- make relative, see :h filename-modifers
		self.relname = vim.fn.fnamemodify(self.filename, ":.")
		local ext = vim.fn.fnamemodify(self.filename, ":e")
		if self.relname == "" then
			self.relname = "[No Name]"
		end
		self.icon, self.color = require("nvim-web-devicons").get_icon_color(self.filename, ext, { default = true })
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
		return { bg = self.color, fg = helper.invertHex(self.color), bold = true }
	end,
}

local FileFlags = {
	init = function(self)
		local ext = vim.fn.fnamemodify(self.filename, ":e")
		self.icon, self.color = require("nvim-web-devicons").get_icon_color(self.filename, ext, { default = true })
	end,
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "[+] ",
		hl = function(self)
			return { bg = self.color }
		end,
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "   ",
		hl = function(self)
			return { bg = self.color }
		end,
	},
	hl = function(self)
		return { fg = helper.invertHex(self.color) }
	end,
}

local FileNameBlockSpace = {
	init = function(self)
		local ext = vim.fn.fnamemodify(self.filename, ":e")
		self.icon, self.color = require("nvim-web-devicons").get_icon_color(self.filename, ext, { default = true })
	end,
	{
		provider = " ",
	},
	hl = function(self)
		return { bg = self.color }
	end,
}

local FileNameBlock = {
	update = { "BufEnter", "DirChanged", "BufModifiedSet", "VimResized" },
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	FileIcon,
	FileName,
	FileNameBlockSpace,
	FileFlags,
	{ provider = "%<" }, -- cut here when there's not enough space
}

local FileType = {
	provider = function()
		return "[" .. vim.bo.filetype .. "]"
	end,
}

local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	provider = "[%7(%l/%3L%):%2c]",
	hl = { fg = utils.get_highlight("String").fg, bold = true },
}

local Diagnostics = {
	-- Since this is nested inside LSPActive the events aren't called
	static = {
		-- error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
		-- warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
		-- info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
		-- hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
		error_icon = " ",
		warn_icon = " ",
		info_icon = " ",
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

local LSPActive = {
	-- Update on "DiagnosticChanged" as nested update clause is ignored
	update = {
		"LspAttach",
		"LspDetach",
		callback = vim.schedule_wrap(function(_)
			vim.cmd.redrawstatus()
		end),
	},
	condition = function(self)
		self.clients = require("hugoulm.utils").lsp_get_clients({ bufnr = 0 })
		return next(self.clients) ~= nil
	end,
	hl = { fg = utils.get_highlight("String").fg, bold = true },
	{
		provider = function(self)
			local names = {}
			for _, server in pairs(self.clients) do
				table.insert(names, server.name)
			end
			return "[ " .. table.concat(names, " ") .. "]"
		end,
	},
}

local DefaultStatusLine = {
	ViMode,
	FileNameBlock,
	Git,
	Align,
	Space,
	Diagnostics,
	Space,
	LSPActive,
	Ruler,
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

local HelpFileName = {
	condition = function()
		return vim.bo.filetype == "help"
	end,
	provider = function()
		local filename = vim.api.nvim_buf_get_name(0)
		return vim.fn.fnamemodify(filename, ":t")
	end,
}

local SpecialStatusline = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "nofile", "prompt", "help", "quickfix" },
			filetype = { "fzf", "^git.*", "fugitive", "fugitiveblame" },
		})
	end,
	Align,
	FileType,
	Space,
	HelpFileName,
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
	{ condition = conditions.is_active, ViMode, Space },
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
	SpecialStatusline,
	TerminalStatusline,
	InactiveStatusline,
	DefaultStatusLine,
}
