local telescope = require("telescope")

telescope.setup({
defaults = {
  mappings = {
    i = {
      ["<Esc>"] = require("telescope.actions").close,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
  },
},
})
telescope.load_extension("fzf")
