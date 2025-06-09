{ config, pkgs, ... }: 
let
  customPkgs = pkgs.extend (final: prev: {
    wikiman = prev.wikiman.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        ./sources.patch
      ];
    });
  });
  
  # Use the customized wikiman
  wikimanWithDocs = customPkgs.wikiman;
  
in {
  home = {
    packages = [ wikimanWithDocs ];
  };
}
