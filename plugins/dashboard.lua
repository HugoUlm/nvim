return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	event = "VimEnter",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	opts = function()
		local logo = [[
 ▄█  ███▄▄▄▄      ▄████████ ███    █▄     ▄████████  ▄█   ▄████████    ▄████████
███  ███▀▀▀██▄   ███    ███ ███    ███   ███    ███ ███  ███    ███   ███    ███
███▌ ███   ███   ███    █▀  ███    ███   ███    ███ ███▌ ███    █▀    ███    ███
███▌ ███   ███   ███        ███    ███  ▄███▄▄▄▄██▀ ███▌ ███          ███    ███
███▌ ███   ███ ▀███████████ ███    ███ ▀▀███▀▀▀▀▀   ███▌ ███        ▀███████████
███  ███   ███          ███ ███    ███ ▀███████████ ███  ███    █▄    ███    ███
███  ███   ███    ▄█    ███ ███    ███   ███    ███ ███  ███    ███   ███    ███
█▀    ▀█   █▀   ▄████████▀  ████████▀    ███    ███ █▀   ████████▀    ███    █▀
                                         ███    ███
		]]
		logo = string.rep("\n", 8) .. logo .. "\n\nHugo Bäckman Ulmgren\n\n"

		local opts = {
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
				header = vim.split(logo, "\n"),
				center = {
					{
						action = require("telescope.builtin").find_files,
						icon = "󰱼  ",
						desc = "Search files",
						key = "f",
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {
						"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
					}
				end,
			},
		}
		-- open dashboard after closing lazy
		if vim.o.filetype == "lazy" then
			vim.api.nvim_create_autocmd("WinClosed", {
				pattern = tostring(vim.api.nvim_get_current_win()),
				once = true,
				callback = function()
					vim.schedule(function()
						vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
					end)
				end,
			})
		end

		return opts
	end,
}
