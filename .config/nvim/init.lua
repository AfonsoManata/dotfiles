-- bootstrap lazy.nvim, LazyVim and your plugins
vim.opt.fileformats = { "unix" }
vim.opt.guicursor = "a:block"
vim.opt.colorcolumn = "80"
vim.g.lazyvim_check_order = false
require("config.lazy")
