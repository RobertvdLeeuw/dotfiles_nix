{ config, pkgs, inputs, ... }:
{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
      {
      enable = true;

      # Instead of using a predefined theme, we'll create a custom one
      theme = {
        name = "tui";
        src = ../modules/spicetify;  # Path to your theme directory, adjust as needed
        appendName = true;  # This adds the theme name as a suffix to the directory
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };

      # You can still use other spicetify features like extensions
      enabledExtensions = with spicePkgs.extensions; [
        # Add any extensions you want here
        fullAppDisplay
        shuffle
      ];
    };
}
