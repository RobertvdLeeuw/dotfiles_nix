local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
desc = "LSP actions",
callback = function(event)
  local opts = { buffer = event.buf }

  vim.keymap.set("n", "<C-b>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "<C-A-b>", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end,
})

l)ocal augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.jq,

		null_ls.builtins.formatting.ruff.with({
      extra_args = { "--fix", "--unfixable F401" },
		}),
		null_ls.builtins.diagnostics.ruff.with({
			extra_args = { "--ignore E741" },
		}),

		null_ls.builtins.formatting.trim_whitespace, -- Trims trailing whitespace
		null_ls.builtins.formatting.trim_newlines, -- Fixes multiple blank lines

		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.mdformat,
		null_ls.builtins.formatting.sqlfmt,
		null_ls.builtins.formatting.rustfmt,
	},

	-- Configure format on save
  on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- Format on save
					vim.lsp.buf.format({
						bufnr = bufnr,
						-- Only use null-ls for formatting
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})

vim.lsp.handlers["textDocument/references"] = function(_, result, ctx, config)
	if not result or #result == 0 then
		vim.notify("No references found", vim.log.levels.INFO)
		return
	end

	local client = vim.lsp.get_client_by_id(ctx.client_id)

	-- Use the built-in quickfix list for displaying references
	vim.fn.setqflist({}, " ", {
		title = "References",
		items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
		context = ctx,
	})

	-- Open quickfix window
	vim.cmd("copen")

	-- Auto-close when selecting a reference
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = vim.api.nvim_get_current_buf(),
		once = true,
		callback = function()
			vim.cmd("cclose")
		end,
	})

	-- Close when pressing Escape in the quickfix window
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			vim.keymap.set("n", "<Esc>", function()
				vim.cmd("cclose")
			end, { buffer = true })
		end,
	})
end

-- Automatic hover information with better capability check
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local bufnr = 0
		-- Get active clients for this buffer
		local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

		-- Check if we have any non-null-ls clients with hover capability
		local has_hover_support = false
		for _, client in ipairs(clients) do
			-- Skip null-ls or check if it actually supports hover for this filetype
			if client.name ~= "null-ls" and client.server_capabilities.hoverProvider then
				has_hover_support = true
				break
			end
		end

		-- Only show hover if we have a proper client with hover support
		if has_hover_support then
			vim.lsp.buf.hover({ focusable = false })
		end
	end,
	buffer = 0,
})

vim.opt.updatetime = 500
vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)
