-- plugins/copilot-chat.lua
-- Adds GitHub Copilot Chat support with floating and vsplit options
-- NixOS: Ensure nodejs, ripgrep, and github-copilot are available in your environment

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      "github/copilot.vim", -- Copilot core plugin
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
      -- Floating Copilot Chat
  { "<leader>cc", function() require("CopilotChat").toggle({ window = { layout = "float", name = "CopilotChatFloat" } }) end, desc = "Copilot Chat (float)" },
  -- Vsplit Copilot Chat
      { "<leader>cC", function()
        vim.cmd('vsplit')
        require("CopilotChat").toggle({ window = { layout = "vsplit", name = "CopilotChatVsplit" } })
      end, desc = "Copilot Chat (vsplit)" },
    },
    config = function()
      require("CopilotChat").setup({
        window = {
          layout = "float", -- default, can be overridden per call
        },
      })
    end,
  },
}
