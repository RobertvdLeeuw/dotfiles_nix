{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          python = [
            "isort"
            "ruff_format"
            "injected"
          ];

          lua = [ "stylua" ];

          rust = lib.generators.mkLuaInline ''{ "rustfmt", lsp_format = "fallback" }'';

          bash = [ "shfmt" ];
          sh = [ "shfmt" ];
          json = [
            "prettier"
            "jq"
          ];
          nix = [
            "nixfmt"
            "injected"
          ];
          sql = [ "sqlfmt" ];
          markdown = [
            "prettier"
            "injected"
          ];

          # Fallback
          "*" = [ "trim_whitespace" ];
        };

        formatters = {
          shfmt = {
            append_args = [
              "-i"
              "2"
              "-ci"
            ];
          };

          ruff_format = {
            append_args = [
              "--line-length"
              "100"
            ];
          };

          nixfmt = {
            append_args = [
              "--width"
              "100"
            ];
          };
        };

        # Default format options
        default_format_opts = {
          lsp_format = "fallback";
          timeout_ms = 3000;
        };

        # Format on save configuration
        format_on_save = lib.generators.mkLuaInline /* lua */ ''
          function()
            if not vim.g.formatsave or vim.b.disableFormatSave then
              return
            else
              return { lsp_format = "fallback", timeout_ms = 1000 }
            end
          end
        '';

        # Notify settings
        notify_on_error = true;
        notify_no_formatters = false;
      };
    };

    # Diagnostic merger (from luaConfigPost)
    luaConfigPost = /* lua */ ''
      local function setup_diagnostic_merger()
      	local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
      	local merge_ns = vim.api.nvim_create_namespace("diagnostic_merger")

      	local function merge_diagnostics(diagnostics)
      		local merged = {}
      		local seen = {}

      		-- Sort diagnostics consistently: by line, column, severity, then source
      		table.sort(diagnostics, function(a, b)
      			if a.lnum ~= b.lnum then
      				return a.lnum < b.lnum
      			end
      			if a.col ~= b.col then
      				return a.col < b.col
      			end
      			if a.severity ~= b.severity then
      				return a.severity < b.severity -- Lower numbers = higher severity
      			end
      			-- Tie-breaker: source name
      			local source_a = a.source or ""
      			local source_b = b.source or ""
      			return source_a < source_b
      		end)

      		for _, diag in ipairs(diagnostics) do
      			local key = string.format("%d:%d:%s", diag.lnum, diag.col, diag.message:sub(1, 50))

      			if not seen[key] then
      				seen[key] = true
      				table.insert(merged, diag)
      			end
      		end

      		return merged
      	end

      	local function refresh_merged_diagnostics(args)
      		local bufnr = args.buf
      		if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      			return
      		end

      		-- Get all current diagnostics for this buffer
      		local all_diagnostics = vim.diagnostic.get(bufnr)
      		local merged_diagnostics = merge_diagnostics(all_diagnostics)

      		-- Clear existing virtual text in our namespace
      		orig_virtual_text_handler.hide(merge_ns, bufnr)

      		-- Show merged diagnostics if we have any
      		if #merged_diagnostics > 0 then
      			-- Pass the full diagnostic config - the original handler extracts virtual_text from it
      			local full_config = vim.diagnostic.config()
      			orig_virtual_text_handler.show(merge_ns, bufnr, merged_diagnostics, full_config)
      		end
      	end

      	-- Override the virtual text handler to prevent individual LSPs from showing diagnostics
      	vim.diagnostic.handlers.virtual_text = {
      		show = function(namespace, bufnr, diagnostics, opts)
      			-- Only show if this is our merged namespace, ignore individual LSP namespaces
      			if namespace == merge_ns then
      				orig_virtual_text_handler.show(namespace, bufnr, diagnostics, opts)
      			end
      		end,

      		hide = function(namespace, bufnr)
      			if namespace == merge_ns then
      				orig_virtual_text_handler.hide(namespace, bufnr)
      			end
      		end,
      	}

      	-- Re-merge diagnostics whenever they change from any source
      	vim.api.nvim_create_autocmd("DiagnosticChanged", {
      		callback = refresh_merged_diagnostics,
      		desc = "Refresh merged diagnostic virtual text",
      	})

      	-- Also refresh on initial buffer diagnostics
      	vim.api.nvim_create_autocmd("LspAttach", {
      		callback = function(args)
      			vim.defer_fn(function()
      				refresh_merged_diagnostics(args)
      			end, 100)
      		end,
      	})
      end

      -- Initialize the merger
      vim.defer_fn(setup_diagnostic_merger, 50)
    '';
  };
}
