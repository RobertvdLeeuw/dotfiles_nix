vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2E3440" })

--  BUG:
--  Slow ctrl W
--  Check if closing terminals leaves dangling processes
--  Error opening terminal

--  TODO:
--  Tab merging and auto close 'empty' tabs
--  Markdown + Nabla
--  Autosession
--  Harpoon
--  If opening file that needs sudo -> some type of warning.
--  EZ (short for 'easy') pane resizing
--  3rd/image.nvim
--  Ctrl J/K for in out terminal
--  Text comp for in string code editing
--  Go to source goes to tab of source if open
--  Alt J/K for tab back/forward
--  Hide mouse in insert mode.
--  ftplugin style (LSP and format per filetype).
