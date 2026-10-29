# Shell extensions
# Again, Vicinae and co. do their own thing
{ lib, pkgs, self, ... }:

{
  environment.sessionVariables.GI_TYPELIB_PATH = [
    "${self.packages.${pkgs.stdenv.hostPlatform.system}.gnome-rounded-blur}/lib/girepository-1.0"
  ];

  _gnome = {
    extensions =
      (with pkgs.gnomeExtensions; [
        caffeine
        just-perfection
        blur-my-shell
        no-overview
        bluetooth-battery-meter
      ])
      ++ [ self.packages.${pkgs.stdenv.hostPlatform.system}.gradia-capture ];

    dconf.user = {
      # Just Perfection
      "org/gnome/shell/extensions/just-perfection" = {
        theme = false;
        top-panel-position = lib.gvariant.mkInt32 1;
        notification-banner-position = lib.gvariant.mkInt32 4;
        support-notifier-type = lib.gvariant.mkInt32 0;
      };

      # Blur My Shell
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        whitelist = [ "com.mitchellh.ghostty" ];
        sigma = lib.gvariant.mkInt32 30;
        opacity = lib.gvariant.mkInt32 255;
        static-blur = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = true;
        static-blur = false;
        unblur-in-overview = true;
        sigma = lib.gvariant.mkInt32 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".blur = false;
      "org/gnome/shell/extensions/blur-my-shell/overview".style-components = lib.gvariant.mkInt32 2;

      # Bluetooth Battery Meter
      "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
        enable-galaxy-buds-device = true;
        modify-quick-settings = true;
        popup-in-quick-settings = true;
        indicator-type = lib.gvariant.mkInt32 2;
        enable-multi-indicator-mode = true;
        enable-tooltip = false;
        level-indicator-type = lib.gvariant.mkInt32 0;
        level-bar-position = lib.gvariant.mkInt32 1;
        level-indicator-color = lib.gvariant.mkInt32 0;
        circle-widget-color = lib.gvariant.mkInt32 1;
      };
    };
  };
}
