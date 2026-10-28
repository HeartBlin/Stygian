# How things look graphically speaking
{ lib, pkgs, ... }:

let
  cursor = {
    package = pkgs.bibata-cursors;
    theme = "Bibata-Modern-Ice";
    size = 24;
  };

  cursorSettings = {
    cursor-theme = cursor.theme;
    cursor-size = lib.gvariant.mkInt32 cursor.size;
  };
in {
  environment.systemPackages = [
    cursor.package
    pkgs.adwaita-icon-theme
  ];

  _gnome.dconf = {
    gdm."org/gnome/desktop/interface" = cursorSettings;
    user."org/gnome/desktop/interface" =
      cursorSettings
      // {
        color-scheme = "prefer-dark";
        accent-color = "blue";
      };
  };

  # X11 cursor fix
  hjem.users.primaryUser.files.".icons/${cursor.theme}".source = "${cursor.package}/share/icons/${cursor.theme}";
}
