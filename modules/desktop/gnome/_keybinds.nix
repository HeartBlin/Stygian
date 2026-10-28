# Keybinds related to GNOME itself
# Vicinae and co. do everything in their own file
{ lib, ... }:

let
  noKeys = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
  workspaceCount = 5; # Also workspaces... they are tied enough
  forWorkspaces = prefix: val:
    lib.listToAttrs (map
      (i: let w = toString i; in lib.nameValuePair "${prefix}-${w}" (val w))
      (lib.range 1 workspaceCount));
in {
  _gnome = {
    keybinds = [
      {
        name = "Chromium";
        command = "chromium";
        binding = "<Super>W";
      }
      {
        name = "VSCodium";
        command = "codium";
        binding = "<Super>C";
      }
      {
        name = "Terminal";
        command = "ghostty";
        binding = "<Super>Return";
      }
    ];

    dconf.user = {
      "org/gnome/mutter".dynamic-workspaces = false;
      "org/gnome/shell/keybindings" = forWorkspaces "switch-to-application" (_: noKeys);
      "org/gnome/desktop/wm/preferences".num-workspaces = lib.gvariant.mkInt32 workspaceCount;
      "org/gnome/desktop/wm/keybindings" =
        { close = [ "<Super>q" ]; }
        // forWorkspaces "switch-to-workspace" (ws: [ "<Super>${ws}" ])
        // forWorkspaces "move-to-workspace" (ws: [ "<Shift><Super>${ws}" ]);
    };
  };
}
