require("lspconfig").jsonls.setup({
	filetypes = { "json", "jsonc" },
	settings = {
		json = {
			schemas = {},
			validate = { enable = true },
			format = { enable = true },
		},
	},
})
