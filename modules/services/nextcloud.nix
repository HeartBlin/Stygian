{ pkgs, ... }:

let
  inherit (import ./_caddy.nix) domain mTLS;
in {
  users.users.nextcloud.extraGroups = [ "music" "store" ];
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud35;

      hostName = "files.heartblin.eu";
      https = true;

      appstoreEnable = false;
      database.createLocally = true;
      configureRedis = true;
      config.dbtype = "mysql";

      maxUploadSize = "5G";
      fastcgiTimeout = 300;

      settings = {
        trusted_proxies = [ "::1" ];
        overwriteprotocol = "https";
        "overwrite.cli.url" = "https://files.heartblin.eu";

        # To satisfy Nextcloud config check
        maintenance_window_start = 1;
        default_phone_region = "RO";
        log_type = "systemd";
      };
    };

    nginx = {
      enable = true;
      virtualHosts."files.heartblin.eu" = {
        listen = [ { addr = "[::1]"; port = 8090; } ];
        rejectSSL = true;
      };
    };

    caddy.virtualHosts."files.${domain}".extraConfig =
      mTLS
      "reverse_proxy http://[::1]:8090";
  };
}
