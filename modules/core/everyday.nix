{
  config,
  pkgs,
  lib,
  hostType,
  inputs,
  ...
}:
{
  # imports = [ inputs.zen-browser.homeModules.twilight ];

  config = lib.mkIf (!config.my.noGUI && !config.my.sudoTools) {
    home.packages =
      with pkgs;
      [
        brave
        # inputs.zen-browser.packages."${system}".specific
        # Dolphin is installed auto via KDE

        libreoffice-qt
        pavucontrol

        blender
        spotify

        whatsie
        discord
        teams

        loupe # Image viewer
        pinta # Linux equiv of paint.net
        gimp
        vlc
      ]
      ++ (lib.optionals (hostType == "laptop") [
        # TODO: Move to options in default.nix
        brightnessctl
        bluez
      ]);

    # xdg.configFile."zen/profiles.ini".force = true;

    # programs.zen-browser = {
    #   enable = true;
    #   setAsDefaultBrowser = true;
    #
    #   policies = {
    #     AutofillAddressEnabled = true;
    #     AutofillCreditCardEnabled = false;
    #     DisableAppUpdate = true;
    #     DisableFeedbackCommands = true;
    #     DisableFirefoxStudies = true;
    #     DisablePocket = true;
    #     DisableTelemetry = true;
    #     DontCheckDefaultBrowser = true;
    #     NoDefaultBookmarks = true;
    #     OfferToSaveLogins = false;
    #     EnableTrackingProtection = {
    #       Value = true;
    #       Locked = true;
    #       Cryptomining = true;
    #       Fingerprinting = true;
    #     };
    #   };
    #
    #   profiles.default = {
    #     # DNS over HTTPS?
    #
    #     extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
    #       ublock-origin
    #       dearrow
    #       multi-account-containers
    #
    #       bitwarden
    #       vimium
    #
    #       darkreader
    #       better-darker-docs
    #     ];
    #
    #     search = {
    #       force = true;
    #       default = "degoog";
    #
    #       engines."degoog".urls = [
    #         {
    #           template = "https://search.rvdlserver.nl/search?q={searchTerms}";
    #         }
    #       ];
    #     };
    #
    #     settings = {
    #       browser = {
    #         tabs.warnOnClose = false;
    #         download.panel.shown = false;
    #
    #         startup.homepage = "https://rvdlserver.nl";
    #         newtabpage.enabled = false;
    #         newtab.url = "https://rvdlserver.nl";
    #       };
    #     };
    #
    #     containersForce = true;
    #
    #     containers = {
    #       work = {
    #         id = 1;
    #         color = "blue";
    #         icon = "briefcase";
    #       };
    #
    #       personal = {
    #         id = 2;
    #         color = "green";
    #         icon = "fingerprint";
    #       };
    #
    #       shopping = {
    #         id = 3;
    #         color = "orange";
    #         icon = "cart";
    #       };
    #
    #       banking = {
    #         id = 4;
    #         color = "red";
    #         icon = "dollar";
    #       };
    #     };
    #
    #     keyboardShortcuts =
    #       let
    #         disabled-keys = [
    #           "key_wrToggleCaptureSequenceCmd"
    #           "key_wrCaptureCmd"
    #           "key_undoCloseWindow"
    #           "key_quitApplication"
    #           "key_sanitize"
    #           "key_screenshot"
    #           "key_switchTextDirection"
    #           "key_showAllTabs"
    #           "key_fullZoomReset"
    #           "toggleSidebarKb"
    #           "viewGenaiChatSidebarKb"
    #           "key_stop"
    #           "viewBookmarksToolbarKb"
    #           "bookmarkAllTabsKb"
    #           "key_viewInfo"
    #           "key_viewSource"
    #           "key_aboutProcesses"
    #           "key_reload_skip_cache"
    #           "key_togglePictureInPicture"
    #           "key_toggleReaderMode"
    #           "key_exitFullScreen"
    #           "key_enterFullScreen"
    #           "key_reload_skip_cache2"
    #           "key_reload2"
    #           "goHome"
    #           "goForwardKb"
    #           "goBackKb"
    #           "key_delete"
    #           "key_toggleMute"
    #           "key_closeWindow"
    #           "printKb"
    #           "key_savePage"
    #           "openFileKb"
    #           "key_openAddons"
    #           "key_search2"
    #           "key_search"
    #           "focusURLBar2"
    #           "focusURLBar"
    #           "zen-compact-mode-show-sidebar"
    #           "zen-workspace-switch-10"
    #           "zen-workspace-switch-9"
    #           "zen-workspace-switch-8"
    #           "zen-workspace-switch-7"
    #           "zen-workspace-switch-6"
    #           "zen-workspace-switch-5"
    #           "zen-workspace-switch-4"
    #           "zen-workspace-switch-3"
    #           "zen-workspace-switch-2"
    #           "zen-workspace-switch-1"
    #           "zen-workspace-forward"
    #           "zen-workspace-backward"
    #           "zen-split-view-grid"
    #           "zen-split-view-vertical"
    #           "zen-split-view-horizontal"
    #           "zen-split-view-unsplit"
    #           "zen-pinned-tab-reset-shortcut"
    #           "zen-toggle-sidebar"
    #           "zen-copy-url"
    #           "zen-copy-url-markdown"
    #           "zen-toggle-pin-tab"
    #           "zen-glance-expand"
    #           "zen-new-empty-split-view"
    #           "zen-new-unsynced-window"
    #           "key_accessibility"
    #           "key_dom"
    #           "key_storage"
    #           "key_performance"
    #           "key_styleeditor"
    #           "key_netmonitor"
    #           "key_jsdebugger"
    #           "key_webconsole"
    #           "key_inspector"
    #           "key_responsiveDesignMode"
    #           "key_browserConsole"
    #           "key_browserToolbox"
    #         ];
    #       in
    #       map (id: {
    #         inherit id;
    #         disabled = true;
    #       }) disabled-keys
    #       ++ [
    #         {
    #           id = "key_selectLastTab";
    #           key = "9";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab8";
    #           key = "8";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab7";
    #           key = "7";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab6";
    #           key = "6";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab5";
    #           key = "5";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab4";
    #           key = "4";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab3";
    #           key = "3";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab2";
    #           key = "2";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_selectTab1";
    #           key = "1";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_restoreLastClosedTabOrWindowOrSession";
    #           key = "t";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "key_privatebrowsing";
    #           key = "n";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "key_fullZoomEnlarge";
    #           key = "+";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_fullZoomReduce";
    #           key = "-";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_gotoHistory";
    #           key = "h";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "viewBookmarksSidebarKb";
    #           key = "b";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "manBookmarkKb";
    #           key = "o";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "addBookmarkAsKb";
    #           key = "d";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_findPrevious";
    #           key = "f";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "key_findAgain";
    #           key = "g";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_find";
    #           key = "f";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_reload";
    #           key = "r";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "showAllHistoryKb";
    #           key = "h";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "goForwardKb2";
    #           key = "l";
    #           modifiers = {
    #             alt = true;
    #           };
    #         }
    #         {
    #           id = "goBackKb2";
    #           key = "h";
    #           modifiers = {
    #             alt = true;
    #           };
    #         }
    #         {
    #           id = "key_selectAll";
    #           key = "a";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_paste";
    #           key = "v";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_copy";
    #           key = "c";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_cut";
    #           key = "x";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_redo";
    #           key = "z";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "key_undo";
    #           key = "z";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_close";
    #           key = "w";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_openDownloads";
    #           key = "j";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_newNavigatorTab";
    #           key = "t";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "key_newNavigator";
    #           key = "n";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "zen-compact-mode-toggle";
    #           key = "s";
    #           modifiers.control = true;
    #         }
    #         {
    #           id = "zen-close-all-unpinned-tabs";
    #           key = "k";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #         {
    #           id = "key_toggleToolbox";
    #           key = "i";
    #           modifiers = {
    #             control = true;
    #             shift = true;
    #           };
    #         }
    #       ];
    #   };
    # };
  };
}
