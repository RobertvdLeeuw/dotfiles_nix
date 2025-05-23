# TODO
 - [x] Git set credentials 
     - [ ] Declarative SSH key stuff too?
 - [ ] dv
     - [ ] Figure out 
        - [ ] UV2Nix
        - [x] Cargo2Nix
            - [ ] shell stuff
        - [x] Direnv
 - [ ] NeoVIM
    - [ ] LSP
        - [ ] Ruff
    - [ ] Surround
    - [ ] Why is Shift+K definition info?
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
        - [ ] Server up/down
        - [ ] Something new (actually important) email (neomutt?)
    - [ ] Horizontals
        - [ ] Bluetooth connect/make work
        - [ ] Redo system stats as one module (cpu + temp, gpu + temp, ram)
             - [ ] Figure out temp.
        - [ ] Internet (connected/not with up down speed) 
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
     - [ ] Stuff like global colors file
 - [ ] Something against those incessant ' files.
