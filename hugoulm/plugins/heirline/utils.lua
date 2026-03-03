local separators = {
	left = "",
	left_lite = "",
	right = "",
	right_lite = "",
}

---@alias MyColor string

local _p = {
	base       = "#1a1a2e",
	mantle     = "#141420",
	surface0   = "#1e1e32",
	surface1   = "#2a2040",
	surface2   = "#3a3a5a",
	overlay0   = "#4a4a6a",
	text       = "#ffffff",
	subtext    = "#c8c8d8",
	purple     = "#C591E8",
	green      = "#69FF94",
	green_dark = "#66F68F",
	teal       = "#56B6C2",
	blue       = "#5FAAE8",
	red        = "#D0666F",
	yellow     = "#DCB977",
	peach      = "#DCB977",
	pink       = "#C591E8",
	mauve      = "#C591E8",
	sapphire   = "#5FAAE8",
	sky        = "#56B6C2",
	lavender   = "#8888cc",
	crust      = "#0e0e1e",
}

---@return table<string, MyColor>
local function palette() return _p end

local function expand_style(tbl)
	if tbl.style then
		for _, style in ipairs(tbl.style) do
			tbl[style] = true
		end
		tbl.style = nil
	end
	return tbl
end

local function format_color(color)
	if type(color) == "number" then
		return string.format("#%06x", color)
	end
	return color
end

local function hex_to_rgb(hex)
	helper = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

local function blend_hex(fg, bg, alpha)
	fg = format_color(fg) or "#ffffff"
	bg = format_color(bg) or "#000000"
	local fr, fg_, fb = hex_to_rgb(fg)
	local br, bg_, bb = hex_to_rgb(bg)
	if not fr or not br then return fg end
	return rgb_to_hex(
		fr * alpha + br * (1 - alpha),
		fg_ * alpha + bg_ * (1 - alpha),
		fb * alpha + bb * (1 - alpha)
	)
end

function darken_color(color, alpha, bg)
	bg = bg or palette().base
	return blend_hex(format_color(color), format_color(bg), alpha)
end

function brighten_color(color, alpha, bg)
	bg = bg or palette().text
	return blend_hex(format_color(color), format_color(bg), alpha)
end

function hl_override()
	local floating_background = palette().base

	if vim.g.floating_border == "none" then
		floating_background = palette().surface0
	end

	local highlights = {
		Error = { fg = palette().red },
		Warning = { fg = palette().yellow },
		Info = { fg = palette().sky },
		Hint = { fg = palette().teal },

		ErrorSign = { fg = palette().red, bg = darken_color(palette().red, 0.095) },
		WarnSign = { fg = palette().yellow, bg = darken_color(palette().yellow, 0.095) },
		InfoSign = { fg = palette().sky, bg = darken_color(palette().sky, 0.095) },
		HintSign = { fg = palette().teal, bg = darken_color(palette().teal, 0.095) },

		CursorLine = { bg = palette().surface0 },
		CursorLineSign = { link = "CursorLine" },
		LineNr = { fg = palette().surface2 },
		CursorLineNr = { fg = palette().lavender, bg = palette().surface0 },
		ColorColumn = { bg = palette().mantle },

		NormalFloat = { bg = floating_background },
		FloatBorder = { fg = palette().mauve, bg = floating_background },
		FloatTitle = { fg = palette().yellow, bg = floating_background },
		TermFloatBorder = { fg = palette().red },

		SnacksPickerMatch = { sp = palette().peach, fg = palette().peach, style = { "underline" } },
		SnacksIndentScope = { fg = palette().mauve },

		BlinkCmpMenu = { link = "NormalFloat" },
		BlinkCmpMenuBorder = { fg = palette().mauve },
		BlinkCmpDocBorder = { fg = palette().green },
		BlinkCmpSignatureHelpBorder = { fg = palette().peach },
		BlinkCmpGhostText = { fg = palette().surface2 },

		GlancePreviewMatch = { bg = darken_color(palette().peach, 0.2) },
		GlanceListMatch = { fg = palette().peach },

		Search = {
			fg = palette().yellow,
			bg = darken_color(palette().yellow, 0.095),
			sp = palette().yellow,
			style = { "bold", "underline" },
		},
		CurSearch = {
			fg = palette().peach,
			bg = darken_color(palette().peach, 0.095),
			sp = palette().peach,
			style = { "bold", "underline" },
		},

		InclineNormal = { fg = palette().base, bg = palette().sapphire, style = { "bold" } },
		InclineNormalNC = { fg = palette().sapphire, bg = darken_color(palette().sapphire, 0.33) },

		EdgyNormal = { bg = palette().mantle },
		TroubleNormal = { bg = palette().mantle },

		TreesitterContext = { bg = palette().base, style = { "italic" }, blend = 0 },
		TreesitterContextSeparator = { fg = palette().surface1 },
		TreesitterContextBottom = { bg = palette().base, sp = palette().surface1, style = { "underdashed" } },
		TreesitterContextLineNumber = { link = "LineNr" },

		DiagnosticLineError = { bg = darken_color(palette().red, 0.095, palette().base) },
		DiagnosticLineWarn = { bg = darken_color(palette().yellow, 0.095, palette().base) },
		DiagnosticLineInfo = { bg = darken_color(palette().sky, 0.095, palette().base) },
		DiagnosticLineHint = { bg = darken_color(palette().teal, 0.095, palette().base) },

		DiagnosticSignError = { fg = palette().red, bg = darken_color(palette().red, 0.095) },
		DiagnosticSignWarn = { fg = palette().yellow, bg = darken_color(palette().yellow, 0.095) },
		DiagnosticSignInfo = { fg = palette().sky, bg = darken_color(palette().sky, 0.095) },
		DiagnosticSignHint = { fg = palette().teal, bg = darken_color(palette().teal, 0.095) },

		IblScope = { fg = palette().mauve },

		ModeNormal = { fg = palette().blue, bg = darken_color(palette().blue, 0.33), style = { "bold" } },
		ModeInsert = { fg = palette().green, bg = darken_color(palette().green, 0.33), style = { "bold" } },
		ModeVisual = { fg = palette().mauve, bg = darken_color(palette().mauve, 0.33), style = { "bold" } },
		ModeOperator = { fg = palette().peach, bg = darken_color(palette().peach, 0.33), style = { "bold" } },
		ModeReplace = { fg = palette().yellow, bg = darken_color(palette().yellow, 0.33), style = { "bold" } },
		ModeCommand = { fg = palette().sky, bg = darken_color(palette().sky, 0.33), style = { "bold" } },
		ModePrompt = { fg = palette().teal, bg = darken_color(palette().teal, 0.33), style = { "bold" } },
		ModeTerminal = { fg = palette().red, bg = darken_color(palette().red, 0.33), style = { "bold" } },

		MacroRecording = { fg = palette().base, bg = palette().pink, style = { "bold" } },

		ModesInsert = { link = "ModeInsert" },
		ModesVisual = { link = "ModeVisual" },

		Comment = { fg = darken_color(palette().lavender, 0.6) },

		IlluminatedWordText = { bg = palette().surface1, style = { "bold", "underdotted" } },
		IlluminatedWordWrite = { bg = palette().surface1, style = { "bold", "underdotted" } },
		IlluminatedWordRead = { bg = palette().surface1, style = { "bold", "underdotted" } },

		Folded = { bg = palette().base, style = { "italic" }, fg = palette().overlay0 },

		GitSignsAdd = { fg = palette().green },
		GitSignsChange = { fg = palette().peach },
		GitSignsDelete = { fg = palette().red },
		GitSignsAddInline = { bg = darken_color(palette().green, 0.50) },
		GitSignsChangeInline = { bg = darken_color(palette().peach, 0.50) },
		GitSignsDeleteInline = { bg = darken_color(palette().red, 0.50) },

		DiffDeleteVirtLn = { fg = darken_color(palette().red, 0.3) },
		DiffviewDiffDeleteDim = { fg = palette().surface0 },
		DiffviewWinSeparator = { fg = palette().crust },

		CustomTabline = { fg = palette().mauve, bg = darken_color(palette().mauve, 0.33) },
		CustomTablineSel = { fg = palette().base, bg = palette().mauve },
		CustomTablineLogo = { fg = palette().mauve },
		CustomTablinePillIcon = { bg = darken_color(palette().mauve, 0.33) },
		CustomTablinePillIconSel = { bg = darken_color(palette().mauve, 0.33) },
		CustomTablineModifiedIcon = { fg = palette().peach, bg = darken_color(palette().peach, 0.33) },
		CustomTablineNumber = { style = { "bold" } },
		CustomTablineLsp = { fg = palette().base, bg = palette().green },
		CustomTablineLspActive = { fg = palette().green, bg = darken_color(palette().green, 0.33), style = { "bold" } },
		CustomTablineLspInactive = { fg = palette().text, bg = darken_color(palette().green, 0.33) },
		CustomTablineCwd = { fg = palette().yellow, bg = darken_color(palette().yellow, 0.33) },
		CustomTablineCwdIcon = { fg = palette().base, bg = palette().yellow },
		CustomTablineGitBranch = { fg = palette().peach, bg = darken_color(palette().peach, 0.33) },
		CustomTablineGitIcon = { fg = palette().base, bg = palette().peach },

		LspSignatureActiveParameter = { bg = darken_color(palette().red, 0.33) },

		CopilotSuggestion = { fg = darken_color(palette().peach, 0.8), style = { "italic" } },

		FlashLabel = { bg = palette().peach, fg = palette().base, style = { "bold" } },
		FlashMatch = { bg = palette().lavender, fg = palette().base },
		FlashBackdrop = { bg = nil, fg = palette().overlay0, style = { "nocombine" } },

		LazyCommitTypeFeat = { sp = palette().blue, style = { "underline" } },

		["@property"] = { fg = brighten_color(palette().yellow, 0.5) },
		["@variable.member"] = { fg = brighten_color(palette().yellow, 0.5) },

		["@lsp.type.property"] = { fg = brighten_color(palette().yellow, 0.5) },
		["@lsp.type.interface"] = { fg = palette().peach },
		["@lsp.type.builtinType"] = { fg = palette().yellow, style = { "bold" } },
		["@lsp.type.enum"] = { fg = palette().teal },
		["@lsp.type.namespace"] = { fg = palette().pink },
		["@lsp.type.unresolvedReference"] = { sp = palette().surface2, style = { "undercurl" } },
		["@lsp.type.derive.rust"] = { link = "@lsp.type.interface" },
		["@lsp.mod.reference"] = { style = { "italic" } },
		["@lsp.mod.mutable"] = { style = { "bold" } },
		["@lsp.mod.trait"] = { fg = palette().sapphire },
	}

	for group, attrs in pairs(highlights) do
		highlights[group] = expand_style(attrs)
	end

	return highlights
end

local function fmt(color)
	if type(color) == "string" then
		return color
	elseif type(color) == "number" then
		return string.format("#%06x", color)
	end
end

local function highlights(key)
	return vim.api.nvim_get_hl(0, { name = key, link = false })
end

local function build_icon_pill(filename, filetype)
	local devicons = require("nvim-web-devicons")
	local icon, icon_hl = devicons.get_icon(filename, filetype, { default = true })

	local fg = palette().text
	if icon_hl then
		local hl = vim.api.nvim_get_hl(0, { name = icon_hl, link = true })
		if hl and hl.fg then
			fg = format_color(hl.fg)
		end
	end

	local icon_bg = fg
	local text_bg = darken_color(fg, 0.3)

	local center = {}
	local right = {}

	table.insert(center, {
		provider = icon .. " ",
		hl = {
			fg = palette().base,
			bg = icon_bg,
		},
	})

	table.insert(right, {
		provider = " " .. filename,
		hl = {
			fg = icon_bg,
			bg = text_bg,
		},
	})

	return build_pill({}, center, right, "provider")
end

function bg(color)
	if type(color) == "string" then
		return fmt(color)
	end

	if not color then
		color = {}
	end

	if not color.bg then
		local fg = color.fg
		if not fg then
			fg = palette().text
		end
		color.bg = darken_color(fmt(fg), 0.3)
	end

	return fmt(color.bg)
end

function build_pill(left, center, right, key, opts)
	key = key or "provider"
	local result = {
		insert = function(self, item)
			if opts then
				vim.tbl_extend("force", item, opts)
			end
			table.insert(self.content, item)
		end,
		content = {},
	}

	local prev_color = highlights("Normal")
	for i, item in ipairs(left) do
		if not item.condition or item.condition() then
			local lite = item.lite and i > 1
			result:insert {
				[key] = lite and separators.left_lite or separators.left,
				hl = {
					fg = lite and palette().base or bg(item.hl),
					bg = bg(prev_color),
				},
			}
			result:insert(item)
			prev_color = item.hl
		end
	end

	local default_bg = "#252d39"

	result:insert { [key] = separators.left, hl = { fg = bg(center.hl or center[1].hl), bg = bg(default_bg) } }
	result:insert(center)
		prev_color = center.hl or center[1].hl

	for _, item in ipairs(right) do
		if not item.condition or item:condition() then
			result:insert { [key] = separators.right, hl = { fg = bg(prev_color), bg = bg(item.hl) } }
			result:insert(item)
			prev_color = item.hl
		end
	end

	result:insert { [key] = separators.right, hl = { fg = bg(prev_color), bg = bg(default_bg) } }

	return result.content
end

return {
	palette = palette,
	darken = darken_color,
	brighten = brighten_color,
	hl = highlights,
	hl_override = hl_override,
	build_pill = build_pill,
	build_icon_pill = build_icon_pill,
}