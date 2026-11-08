# How things look graphically speaking
{ lib, pkgs, self, ... }:

let
  cursor = {
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-modern-ice;
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
  systemd.user.tmpfiles.rules = [
    "L+ %h/.icons/${cursor.theme} - - - - ${cursor.package}/share/icons/${cursor.theme}"
  ];
}
