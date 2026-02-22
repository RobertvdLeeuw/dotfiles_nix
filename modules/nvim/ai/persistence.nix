{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    # CodeCompanion Chat Persistence (Inline Version)
    # Auto-saves marked chats and restores them on startup
    # Usage: Press <A-s> in any chat buffer to toggle saving
    luaConfigPost = /* lua */ "";
  };
}
