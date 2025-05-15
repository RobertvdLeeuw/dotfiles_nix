require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
      completion = {
        autoimport = {
          enable = true,
        },
        postfix = {
          enable = true,
        },
      },
      imports = {
        granularity = {
          group = "module",
        },
      },
    },
  },
})
