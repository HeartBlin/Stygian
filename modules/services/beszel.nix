{ config, ... }:

let
  inherit (import ./_caddy.nix) domain mTLS;
in {
  services = {
    beszel = {
      hub = {
        enable = true;
        host = "[::1]";
        port = 8100;
      };

      agent = {
        enable = true;
        smartmon.enable = true;
        environmentFile = config.age.secrets.beszel.path;
        environment = {
          HUB_URL = "http://[::1]:8100";
          DISABLE_SSH = "true";
        };
      };
    };

    caddy.virtualHosts."info.${domain}".extraConfig =
      mTLS
      "reverse_proxy http://[::1]:8100";
  };
}
