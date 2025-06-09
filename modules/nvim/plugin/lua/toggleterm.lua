require("toggleterm").setup({
  size = 30,
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  open_mapping = [[<C-Space>]],
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  on_open = function(term)
    -- Set up terminal-specific options when opened
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "n",
      "<Esc>",
      "<cmd>close<CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "n",
      "<C-Space>",
      "<cmd>close<CR>",
      { noremap = true, silent = true }
    )
  end,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})
