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
        lsp.enable = true;
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
      pkgs.fzf
      pkgs.ripgrep
      pkgs.yazi

      # Formatter packages
      pkgs.stylua # Lua
      pkgs.shfmt # Shell/Bash
      pkgs.nodePackages.prettier # JSON, Markdown
      pkgs.jq # JSON fallback
      pkgs.nixfmt # Nix
      pkgs.rustfmt # Rust
      pkgs.ruff # Python (includes ruff_format and ruff linter)
      pkgs.python311Packages.isort # Python import sorting
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
