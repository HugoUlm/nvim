return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = "claude-sonnet-4-5",
      window = {
        layout = "vertical",
        width = 0.4,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>",   desc = "Copilot Chat Toggle",    mode = { "n", "v" } },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>",    desc = "Copilot Chat Reset" },
      { "<leader>cm", "<cmd>CopilotChatModels<cr>",   desc = "Copilot Chat Models" },
      { "<leader>cp", "<cmd>CopilotChatPrompts<cr>",  desc = "Copilot Chat Prompts" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>",  desc = "Copilot Chat Explain",   mode = { "n", "v" } },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>",      desc = "Copilot Chat Fix",       mode = { "n", "v" } },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>",    desc = "Copilot Chat Tests",     mode = { "n", "v" } },
      { "<leader>cR", "<cmd>CopilotChatReview<cr>",   desc = "Copilot Chat Review",    mode = { "n", "v" } },
    },
  },
}
