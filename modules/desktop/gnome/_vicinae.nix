{ lib, pkgs, ... }:

let
  theme = {
    name = "libadwaita-dark";
    icon_theme = "Adwaita";
  };

  vicinaeSettings = pkgs.writeText "vicinae-settings.json" (builtins.toJSON {
    "$schema" = "https://vicinae.com/schemas/config.jsonc";
    pop_to_root_on_close = true;
    encrypt_sensitive_data = true;
    favicon_service = "google";

    font = {
      rendering = "qt";
      normal.family = "Outfit";
    };

    theme = {
      light = theme;
      dark = theme;
    };

    launcher_window = {
      opacity = 1;
      client_side_decorations.enabled = true;
      compact_mode.enabled = true;
    };

    providers.clipboard.preferences = {
      eraseOnStartup = true;
      ignorePasswords = true;
      monitoring = true;
    };

    tray.enabled = false;
    updates.show_notice = false;
    telemetry.system_info = false;
  });

  vicinaeDesktop = pkgs.writeText "vicinae.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=Vicinae
    Exec=${pkgs.vicinae}/bin/vicinae server
    X-GNOME-Autostart-enabled=true
  '';
in {
  environment.systemPackages = [ pkgs.vicinae ];

  _gnome = {
    extensions = [ pkgs.gnomeExtensions.vicinae ];
    keybinds = [
      {
        name = "Vicinae";
        command = "vicinae toggle";
        binding = "<Super>Space";
      }
    ];

    dconf.user = {
      "org/gnome/shell/extensions/vicinae".show-status-indicator = false;
      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        switch-input-source-backward = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
      };
    };
  };

  environment.etc."xdg/autostart/vicinae.desktop".source = vicinaeDesktop;
  systemd.user.tmpfiles.rules = [
    "L+ %h/.config/vicinae/settings.json - - - - ${vicinaeSettings}"
  ];
}
