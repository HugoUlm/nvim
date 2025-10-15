vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "View [l]int" })
vim.keymap.set("n", "gC", "<cmd>lua vim.diagnostic.close_float()<CR>", { desc = "[C]lose lint" })

vim.keymap.set("n", "<", "<C-w><")
vim.keymap.set("n", ">", "<C-w>>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with row under" })

vim.keymap.set("n", "<leader>T", ":vert term<CR>", { desc = "Toogle [T]erminal vertically" })

vim.keymap.set("v", "C", "<C-q>")

vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")

vim.keymap.set("n", "<C-s>", ":LetItSnow<CR>")

vim.keymap.set("n", "dgw", ":g/<C-r><C-w>/d", { desc = "Delete all occurrences of current word" })
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
	{ desc = "Replace current word in file" }
)

vim.keymap.set("x", "<leader>s", [[:s/\(\w.*\)/]], { desc = "Replace selected line(s)" })

vim.keymap.set("n", "<C-f>", [[/\<<C-r><C-w>\><CR>]], { desc = "Search current word in file" })

local function safe_code_action()
	---@diagnostic disable-next-line: missing-parameter
	local actions = require("tiny-code-action").code_action()
	if actions then
		actions()
	else
		print("No code actions available")
	end
end

vim.keymap.set("n", "<leader>ca", function()
	safe_code_action()
end, { desc = "[C]ode [A]ction", noremap = true, silent = true })

vim.keymap.set('n', 'K', function()
	vim.diagnostic.open_float()
end, { desc = 'Diagnostic float' })

vim.keymap.set("n", "<leader>aa", function()
	require("harpoon.mark").add_file()
end, { desc = "Add buffer to Harpoon" })

vim.keymap.set("n", "<leader>af", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Toggle Harpoon menu" })

