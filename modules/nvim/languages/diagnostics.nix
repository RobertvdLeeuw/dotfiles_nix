{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    diagnostics = {
      enable = true;
      config = {
        underline = false;

        virtual_text = {
          spacing = 4;
          prefix = "■";
          format = lib.generators.mkLuaInline ''
            function(diagnostic)
              return diagnostic.message
            end
          '';
        };

        signs = false;

        severity_sort = true;

        float = {
          severity_sort = true;

          focusable = false;
          border = "single";
          source = "always";
          header = "";
          prefix = "";
        };

        update_in_insert = false;
      };

      nvim-lint = {
        enable = true;

        # Configure linters by filetype
        linters_by_ft = {
          # Python - use ruff for comprehensive linting
          python = [ "ruff" ];

          lua = [ "luacheck" ];

          # Rust - use clippy for advanced linting (beyond LSP)
          rust = [ "clippy" ];

          # Shell/Bash - use shellcheck for shell script analysis
          bash = [ "shellcheck" ];
          sh = [ "shellcheck" ];

          # Nix - use statix for static analysis and nix-linter
          nix = [
            "statix"
            "nix"
          ];

          # SQL - use sqlfluff for SQL style and error checking
          sql = [ "sqlfluff" ];

          # Markdown - use markdownlint for style and formatting issues
          markdown = [ "markdownlint" ];

          # YAML - use yamllint
          yaml = [ "yamllint" ];
          yml = [ "yamllint" ];
        };

        # Customizations for specific linters
        linters = {
          ruff = {
            args = [
              "--output-format"
              "json"
              "--no-cache"
              "--exit-zero"
              "--stdin-filename"
              (lib.generators.mkLuaInline "vim.api.nvim_buf_get_name(0)")
              "-"
            ];
          };

          luacheck = {
            args = [
              "--globals"
              "vim"
              "--formatter"
              "plain"
              "--codes"
              "--ranges"
              "-"
            ];
          };

          shellcheck = {
            args = [
              "--format"
              "json"
              "-"
            ];
          };

          markdownlint = {
            args = [
              "--stdin"
              "--json"
            ];
          };

          yamllint = {
            args = [
              "--format"
              "parsable"
              "-"
            ];
          };
        };
      };
    };
  };
}
