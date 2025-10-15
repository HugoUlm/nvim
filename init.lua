vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.editorconfig = true

local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/?.lua" .. ";" .. config_path .. "/?/init.lua"

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

-- Listen to LSP Attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ timeout = 1000, async = false })
      end,
    })
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= -1 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("hugoulm.plugins.mason"),
  --require("hugoulm.plugins.roslyn"),
  require("hugoulm.plugins.nvim-cmp"),
  require("hugoulm.plugins.lsp-config"),
  require("hugoulm.plugins.debug"),
  require("hugoulm.plugins.lensline"),
  require("hugoulm.plugins.copilot"),
  require("hugoulm.plugins.autopairs"),
  require("hugoulm.plugins.neo-tree"),
  require("hugoulm.plugins.gitsigns"),
  require("hugoulm.plugins.surround"),
  require("hugoulm.plugins.heirline.heirline"),
  require("hugoulm.plugins.let-it-snow"),
  --require("hugoulm.plugins.smear-cursor"),
  require("hugoulm.plugins.colors"),
  require("hugoulm.plugins.fugitive"),
  require("hugoulm.plugins.lazydev"),
  require("hugoulm.plugins.luvit"),
  require("hugoulm.plugins.sleuth"),
  require("hugoulm.plugins.telescope"),
  require("hugoulm.plugins.treesitter"),
  require("hugoulm.plugins.which-key"),
  require("hugoulm.plugins.icons"),
  require("hugoulm.plugins.tiny-code-action"),
  require("hugoulm.plugins.snacks"),
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

local dap = require("dap")

dap.adapters.coreclr = {
  type = "executable",
  command = "/Users/wio950/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
    env = {
      ASPNETCORE_ENVIRONMENT = function()
        -- todo: request input from ui
        return "Development"
      end,
      ASPNETCORE_URLS = function()
        -- todo: request input from ui
        return "http://localhost:5050"
      end,
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
