require('lspconfig').basedpyright.setup({
  capabilities = capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off",
        diagnosticMode = "workspace",

        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = "warning",
          reportOptionalMemberAccess = "none",
          reportUnknownMemberType = "none",
          reportUnknownParameterType = "none",
          reportMissingTypeStubs = "none",
        },

        useLibraryCodeForTypes = true,
        autoSearchPaths = true,
        logLevel = "Information",
      },
    },
  },
})

-- require('lspconfig').ruff.setup({
--   capabilities = capabilities,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if client == nil then
-- 			return
-- 		end
-- 		if client.name == "ruff" then
-- 			-- Disable hover in favor of Pyright
-- 			client.server_capabilities.hoverProvider = false
-- 		end
-- 	end,
-- 	desc = "LSP: Disable hover capability from Ruff",
-- })
