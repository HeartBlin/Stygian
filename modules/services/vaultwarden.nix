let
  inherit (import ./_caddy.nix) domain mTLS;
in {
  services = {
    vaultwarden = {
      enable = true;
      backupDir = "/data/vaultwarden";
      config = {
        DOMAIN = "https://vault.${domain}";
        SIGNUPS_ALLOWED = "false";
        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = "8222";
        ROCKET_LOG = "critical";
        SHOW_PASSWORD_HINT = "false";
        INVITATIONS_ALLOWED = "false";
      };
    };

    caddy.virtualHosts."vault.${domain}".extraConfig =
      mTLS
      "reverse_proxy http://[::1]:8222";
  };
}
