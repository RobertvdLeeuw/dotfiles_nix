# Modularization Notes

## Overview
Successfully split the monolithic nvim.nix (2151 lines) into a modular directory structure following state locality principles.

## Key Decisions

### Removed Features
1. **vim.projects.project-nvim** - Completely removed from configuration
2. **Telescope projects extension** - Removed from telescope.nix
3. **<C-p> keymap** - Removed (was for project picker)

### Preserved Elements
1. **Yazi config_home path** - Kept as `/etc/nixos/modules/nvim/plugin/yazi/` (unchanged)
2. **expected_lsps table** - Intentionally duplicated in ui/statusline.nix (locality over DRY)
3. **All plugin versions and hashes** - Preserved exactly as-is
4. **All custom package builds** - Maintained without modification

### luaConfigPost Distribution
The large luaConfigPost block (lines 1001-1552 in original) was split as follows:
- **Devcontainer hotfix** → tools/devcontainers.nix
- **Async container status checker** → ui/statusline.nix
- **Diagnostic merger** → languages/formatting.nix
- **vim.opt.shortmess** → ui/statusline.nix
- **CodeCompanion setup** → ai/codecompanion.nix
- **CodeCompanion persistence** → ai/persistence.nix

### Autocmd Placement
Following "no grouped autocmd files" principle:
- CodeCompanion loading indicators → ai/codecompanion.nix
- Searchcount timer reset → ui/statusline.nix
- Fold opening → core/options.nix
- Colorizer attachment → ui/visuals.nix
- Alt+b buffer tracking → core/keymaps.nix

### Keymap Pattern
All keymap definitions remain in core/keymaps.nix for easy overview. Complex callback logic extracted to domain files:
- CodeCompanion keymaps → Functions in ai/codecompanion.nix, called via `require('codecompanion_keymaps')`
- Keymap actions reference these functions, maintaining code locality

### State Locality Examples
1. **Statusline (ui/statusline.nix)**: Contains ALL statusline-related code including:
   - Complete lualine configuration
   - LSP status widget with expected_lsps table (duplicated here)
   - Devcontainer status widget
   - Searchcount widget + timer logic
   - Async container checker
   - Searchcount autocmd
   - vim.opt.shortmess setting (related to searchcount)

2. **CodeCompanion (ai/codecompanion.nix)**: Contains:
   - Plugin enable
   - Setup configuration
   - Loading indicator autocmds
   - Keymap callback functions
   - Fullscreen state management

## Module Structure

### Core
- **options.nix**: Vim settings, fold config, fold opening autocmd
- **keymaps.nix**: ALL keymap definitions (delegates complex logic to domain files)
- **extra.nix**: Clipboard, autopairs, comment-nvim

### UI
- **visuals.nix**: Theme, borders, rainbow delimiters, cinnamon, cursorline, colorizer, colorful-menu
- **statusline.nix**: Complete lualine with all widgets, timer logic, async checker
- **extra.nix**: Glance-nvim, todo-comments

### Languages
- **languages.nix**: vim.languages.*, treesitter, render-markdown, extraPackages
- **completion.nix**: Blink-cmp, friendly-snippets, luasnip
- **formatting.nix**: Conform-nvim, diagnostic merger
- **diagnostics.nix**: vim.diagnostics, nvim-lint
- **lsp/python.nix**: Basedpyright and ty LSP configs with devcontainer integration

### Tools
- **telescope.nix**: Telescope + fzf extension (projects removed)
- **filenav.nix**: Yazi + harpoon
- **terminal.nix**: Toggleterm + devcontainer shell function
- **devcontainers.nix**: Devcontainers-nvim, netman-nvim, container_is_running hotfix

### AI
- **codecompanion.nix**: Plugin config, setup, autocmds, keymap callbacks
- **persistence.nix**: Complete CodeCompanion chat persistence system

### Extra
- **unsorted.nix**: nvim-luapad (Lua REPL)

## Ambiguous Placements

### nvim-luapad
Placed in extra/unsorted.nix as a general development utility. Could potentially move to tools/ if deemed more appropriate.

## Verification Checklist
- [x] All code from original accounted for
- [x] Projects-related features removed completely
- [x] All Lua strings prefixed with `/* lua */`
- [x] luaConfigPost used appropriately throughout
- [x] Autocmds placed in relevant files, not grouped
- [x] Keymap logic extracted to domain files where complex
- [x] Yazi path preserved unchanged
- [x] All plugin hashes and versions preserved
- [x] expected_lsps duplicated in statusline (intentional)
- [x] Proper Nix syntax and formatting
- [x] Files properly importable and merge cleanly via lib.mkMerge

## Implementation Notes
- default.nix uses lib.mkMerge to combine all modules
- Each module returns a partial programs.nvf configuration
- Modules are self-contained but coordinate via shared state (e.g., vim.g.devcontainer_running)
- CodeCompanion keymap callbacks exported to global scope via _G.codecompanion_keymaps

## Future Considerations
1. Could extract LSP configurations into language-specific files if needed
2. Consider moving nvim-luapad from extra/unsorted.nix if it becomes more integral
3. Expected_lsps table could be made configurable if duplication becomes problematic
