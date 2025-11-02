---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>y", "<cmd>Yazi cwd<CR>", desc = "New Yazi note" },
  },
  opts = {
    open_for_directories = false,
    keymaps = { show_help = "<f1>" },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
