# This is the "glue" file
{ config, lib, ... }:

let
  keybindBase = "org/gnome/settings-daemon/plugins/media-keys";
  keybindPath = i: "${keybindBase}/custom-keybindings/custom${toString i}";
in {
  options._gnome = {
    dconf = {
      user = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
      };

      gdm = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
      };
    };

    extensions = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.package;
    };

    keybinds = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          command = lib.mkOption { type = lib.types.str; };
          binding = lib.mkOption { type = lib.types.str; };
        };
      });
    };
  };

  config = {
    programs.dconf = {
      enable = true;
      profiles = {
        user.databases = [ { settings = config._gnome.dconf.user; lockAll = true; } ];
        gdm.databases = [ { settings = config._gnome.dconf.gdm; lockAll = true; } ];
      };
    };

    environment.systemPackages = config._gnome.extensions;
    _gnome.dconf.user = lib.mkMerge [
      (lib.mkIf (config._gnome.extensions != [ ]) {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = map (ext: ext.extensionUuid) config._gnome.extensions;
        };
      })

      (lib.mkIf (config._gnome.keybinds != [ ]) (
        {
          "${keybindBase}".custom-keybindings =
            lib.imap0 (i: _: "/${keybindPath i}/") config._gnome.keybinds;
        }
        // lib.listToAttrs (
          lib.imap0 (i: kb:
            lib.nameValuePair (keybindPath i) { inherit (kb) name command binding; })
          config._gnome.keybinds
        )
      ))
    ];
  };
}
