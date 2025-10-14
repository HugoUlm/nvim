return {
  'github/copilot.vim',
  config = function()
    vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
      fg = '#d4b48c',
      italic = true,
      nocombine = true,
    })

    vim.g.copilot_no_tab_map = true
    local map = function(lhs, rhs)
      vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false, silent = true })
    end

    map('<C-y>', 'copilot#Accept("<CR>")') -- accept all
    map('<C-n>', 'copilot#Next()')         -- next suggestion
    map('<C-p>', 'copilot#Previous()')     -- previous suggestion
    map('<C-d>', 'copilot#Dismiss()')      -- dismiss
    map('<C-Y>', 'copilot#AcceptWord()')   -- accept word
    map('<C-e>', 'copilot#Suggest()')      -- trigger suggestion
  end,
}
