# TODO

- [x] Git set credentials
  - [ ] Declarative SSH key stuff too?
- [ ] dv
  - [ ] Figure out
    - [ ] UV2Nix
    - [x] Cargo2Nix
      - [ ] Figure out more maintained alternative
      - [ ] shell stuff
    - [x] Direnv
- [ ] NeoVIM
  - [ ] CoC Nvim?
  - [ ] Something fullscreen terminal
  - [ ] Shift+F5/6 to open last run output
  - [ ] Treesitter - figure out lua + bash in Nix injections.
  - [ ] LSP
    - [ ] Ruff
    - [ ] Fix rust cmp doubling
  - [ ] Surround
  - [ ] Why is Shift+K definition info?
    - It's better than hover, though.
  - [x] Fix terminal
    - [x] Fix F5
    - [ ] Fix F6 once UV is figured out
  - [ ] Try harpoon
  - [ ] Tab completion
    - [ ] NeoCodium
  - [x] MD render
    - [ ] with Nabla
- [ ] Waybar
  - [ ] All
    - [ ] Internet (connected/not with up down speed)
      - [ ] Server up/down
    - [ ] Current and/or next event on (shared) calendar?
      - [ ] Eww for calendar popup
    - [ ] Something new (actually important) email (neomutt?)
  - [ ] Horizontals
    - [ ] Bluetooth connect/make work
- [ ] Eza
- [ ] Fix cliphist menu
- [ ] Alternative browser
- [ ] Package MO2 and PR in Nixpkgs.
- [ ] https://github.com/Mic92/nix-fast-build
- [ ] https://www.youtube.com/watch?v=FYOKD5TCmPY
  - [ ] Static IP
- [ ] Nix dependency search?
  - nix-locate
  - ```nix repl
    nix-repl> :l <nixpkgs>
    nix-repl> pkgs.tbb
    «derivation /nix/store/...»
    nix-repl> builtins.attrNames (builtins.filter (n: builtins.match "tbb.*" n != null) (builtins.attrNames pkgs))
    ```
- [ ] Spicetify fix now playing bottom not working.
- [ ] Look into snowfall
- [ ] Base (probably not nix) for non-nix configs.
  - Stuff like global colors file
- [ ] Something against those incessant ' files.
- [ ] Fix starship prompt and alacritty cursor on vi mode
- [ ] Something instant prompt too like power10k? Might have to PR
- [ ] Look into small sys snapshot that complement NixOS rollback.
- [ ] Wikiman
  - [ ] mkOutOfStoreSymlink?
- [ ] Something notify lekkerspelen live
- [ ] Navi?
- [ ] Something for easy nixpkgs and homeman CLI packages/options search
- [ ] Stylix
- [ ] Yolk? Smart templathing thing for dotfiles, might lessen rebuilds.
