{ config, ... }:

let
  inherit (import ./_caddy.nix) domain mTLS;
in {
  services = {
    slskd = {
      enable = true;
      environmentFile = config.age.secrets.slskd.path;
      openFirewall = true; # This is for the P2P listener
      settings = {
        shares.directories = [ "[Music]/data/music" ];
        soulseek.listen_port = 50300;
        web = {
          ip_address = "[::1]";
          port = 5030; # WebUI
        };
      };
    };

    caddy.virtualHosts."soul.${domain}".extraConfig =
      mTLS
      "reverse_proxy http://[::1]:5030";
  };

  systemd.services.slskd = {
    environment.HOME = "/var/lib/slskd";
    serviceConfig = {
      SupplementaryGroups = [ "music" ];
      ReadOnlyPaths = [ "/data/music" ];
    };
  };
}
