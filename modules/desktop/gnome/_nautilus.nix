{ config, lib, pkgs, ... }:

let
  inherit (config.users.users.primaryUser) home;

  userDirs = [
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Projects"
    "Public"
    "Videos"
  ];

  payday = ".steam/steam/steamapps/common/PAYDAY%202";
  extraBookmarks = [
    { path = "${payday}/mods"; label = "Mods"; }
    { path = "${payday}/assets/mod_overrides"; label = "Mod Overrides"; }
  ];
in {
  environment.systemPackages = with pkgs; [
    nautilus
    sushi
    nautilus-python
  ];

  _gnome = {
    keybinds = [
      {
        name = "Nautilus";
        command = "nautilus -w";
        binding = "<Super>E";
      }
    ];

    dconf.user."org/gnome/nautilus/icon-view".captions = [
      "size"
      "none"
      "none"
    ];
  };

  hjem.users.primaryUser.files.".config/gtk-3.0/bookmarks" = {
    generator = { home, userDirs, extraBookmarks }: lib.concatLines (
      map
      (dir: "file://${home}/${dir} ${dir}")
      userDirs
      ++ map
      ({ path, label }: "file://${home}/${path} ${label}")
      extraBookmarks
    );

    value = { inherit home userDirs extraBookmarks; };
  };
}
