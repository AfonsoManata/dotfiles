local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "lazyvim.plugins" },
  { import = "lazyvim.plugins.extras" },

  { "dstein64/snacks.nvim" },
  -- Colorscheme
  { "gruvbox-community/gruvbox", lazy = false },

  -- LSP / Mason
  { "mason-org/mason.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Yazi.nvim
  { "yazi-vim/yazi.nvim" },
})
