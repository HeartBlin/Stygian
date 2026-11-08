{ config, pkgs, ... }:

{
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.caddy.path
  ];

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  services.caddy = {
    enable = true;
    enableReload = true;
    package = pkgs.caddy.withPlugins {
      hash = "sha256-q86gQb5S1bg383aqd1bQuuoURWHuz8E8IPP1s2LEXq8=";
      plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
    };

    globalConfig = ''
      grace_period 15s
      acme_dns ovh {
        endpoint {$OVH_ENDPOINT}
        application_key {$OVH_APPLICATION_KEY}
        application_secret {$OVH_APPLICATION_SECRET}
        consumer_key {$OVH_CONSUMER_KEY}
      }
    '';
  };
}
