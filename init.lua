vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("hugoulm.schedules.ruler")
require("hugoulm.schedules.clipboard")
require("hugoulm.maps.remap")
require("hugoulm.maps.options")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("hugoulm.plugins.debug"),
	require("hugoulm.plugins.lint"),
	require("hugoulm.plugins.autopairs"),
	require("hugoulm.plugins.neo-tree"),
	require("hugoulm.plugins.gitsigns"),
	require("hugoulm.plugins.codelens"),
	require("hugoulm.plugins.surround"),
	require("hugoulm.plugins.heirline.heirline"),
	require("hugoulm.plugins.lsp-lens"),
	require("hugoulm.plugins.dashboard"),
	require("hugoulm.plugins.let-it-snow"),
	require("hugoulm.plugins.smear-cursor"),
	require("hugoulm.plugins.colors"),
	require("hugoulm.plugins.fugitive"),
	require("hugoulm.plugins.autocomplete"),
	require("hugoulm.plugins.autoformat"),
	require("hugoulm.plugins.lazydev"),
	require("hugoulm.plugins.lsp-config"),
	require("hugoulm.plugins.luvit"),
	require("hugoulm.plugins.sleuth"),
	require("hugoulm.plugins.telescope"),
	require("hugoulm.plugins.treesitter"),
	require("hugoulm.plugins.which-key"),
	require("hugoulm.plugins.icons"),
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
