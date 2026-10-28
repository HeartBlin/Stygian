# Things that don't fit in any other cathegory
{ lib, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  _gnome.dconf.user = {
    "org/gnome/desktop/input-sources".sources = [ (lib.gvariant.mkTuple [ "xkb" "ro" ]) ];
    "org/gnome/desktop/interface".enable-hot-corners = false;
    "org/gnome/desktop/peripherals/touchpad".natural-scroll = false;
    "org/gnome/desktop/peripherals/mouse".natural-scroll = false;
    "org/gnome/desktop/sound".allow-volume-above-100-percent = true;
    "org/gnome/mutter".attach-modal-dialogs = false;
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;
    "org/gnome/shell" = {
      always-show-log-out = true;
      favorite-apps =
        lib.gvariant.mkEmptyArray lib.gvariant.type.string;
    };
  };
}
