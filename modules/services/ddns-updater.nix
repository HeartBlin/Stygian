{ config, ... }:

{
  services.ddns-updater = {
    enable = true;
    environment = {
      SERVER_ENABLED = "no";
      CONFIG_FILEPATH = "%d/config.json";
    };
  };

  systemd.services.ddns-updater.serviceConfig.LoadCredential = ''
    config.json:${config.age.secrets.ddns-updater.path}
  '';
}
