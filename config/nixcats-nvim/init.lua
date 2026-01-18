vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("ui")

require("plugins.lsp")
require("plugins.completion")
require("plugins.treesitter")
require("plugins.navigation")
require("plugins.lint")
