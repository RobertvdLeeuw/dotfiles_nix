require("nvim-treesitter.configs").setup({
  indent = { enable = true },
  fold = { enable = true },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Configure folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Start with all folds open
vim.opt.foldenable = false
vim.opt.foldlevel = 0

-- Toggle fold under cursor
vim.keymap.set("n", "<F1>", "za", { noremap = true, silent = true, desc = "Toggle fold" })
