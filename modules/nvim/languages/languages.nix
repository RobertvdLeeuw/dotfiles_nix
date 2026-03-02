{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    languages = {
      bash = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      lua = {
        enable = true;
        treesitter.enable = true;
        lsp = {
          lazydev.enable = true;
          enable = true;
          # servers = [ ];
        };
      };
      python = {
        enable = true;
        treesitter.enable = true;
        lsp = {
          enable = true;
        };
      };
      rust = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      sql = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      json = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      yaml = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      nix = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
      markdown = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;

        extensions.render-markdown-nvim = {
          enable = true;
          setupOpts = {
            completions.lsp.enabled = true;
            render_modes = true;
            file_types = [
              "markdown"
              "codecompanion"
            ];
          };
        };
      };
    };

    treesitter = {
      enable = true;
      fold = true;
    };

    extraPackages = [
      # TODO: Similar logic in default.nix for luaConfig so this can be split up.
      pkgs.fzf
      pkgs.ripgrep
      pkgs.yazi

      pkgs.vectorcode

      pkgs.lua51Packages.luv # For vim.uv types
      pkgs.luajitPackages.luv # For vim.uv types

      # Formatter packages
      pkgs.stylua # Lua
      pkgs.shfmt # Shell/Bash
      pkgs.nodePackages.prettier # JSON, Markdown
      pkgs.jq # JSON fallback
      pkgs.nixfmt # Nix
      pkgs.rustfmt # Rust
      pkgs.ruff # Python (includes ruff_format and ruff linter)
      pkgs.python313Packages.isort # Python import sorting
      pkgs.python313Packages.sqlfmt # SQL

      # Linter packages
      pkgs.luajitPackages.luacheck # Lua linter
      pkgs.clippy # Rust linter (usually comes with rust toolchain)
      pkgs.shellcheck # Shell script linter
      pkgs.statix # Nix static analyzer
      pkgs.sqlfluff # SQL linter
      pkgs.nodePackages.markdownlint-cli # Markdown linter
      pkgs.yamllint # YAML linter
    ];
  };
}
