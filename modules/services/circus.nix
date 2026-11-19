{ config, inputs, ... }:

let
  inherit (import ./utils/_domain.nix) domain;
  inherit (import ./utils/_mTLS.nix) mTLS;
in {
  imports = [ inputs.circus.nixosModules.default ];
  services = {
    circus = {
      enable = true;
      server.enable = true;
      evaluator.enable = true;
      queueRunner.enable = true;

      settings = {
        database.url = "postgresql:///circus?host=/run/postgresql&user=circus";
        server = {
          host = "::1";
          port = 3000;
          force_secure_cookies = true;
        };

        evaluator = {
          poll_interval = 300;
          restrict_eval = true;
          systems = [ "x86_64-linux" ];
        };

        queue_runner = {
          workers = 2;
          build_timeout = 3600;
        };

        gc = {
          enable = true;
          max_age_days = 30;
        };

        signing = {
          enabled = true;
          key_file = config.age.secrets.circusSigningKey.path;
          public_key = "cache.${domain}-1:H5dUOEabeo7ytKW/UshbZ5+bWWgrKwH3aMyKP32qP6g=";
        };

        cache = {
          enabled = true;
          cache_url = "https://cache.${domain}/nix-cache";
          upstreams = [
            {
              url = "https://cache.nixos.org";
              public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
            }
          ];
        };

        declarative = {
          users = [
            {
              username = "heartblin";
              email = "heartblin@reason.local";
              password_file = config.age.secrets.circusAdminPassword.path;
              role = "admin";
            }
          ];

          api_keys = [
            {
              name = "admin-key";
              key_file = config.age.secrets.circusAdminKey.path;
              role = "admin";
            }
          ];

          projects = [
            {
              name = "Hyperbolic";
              repository_url = "https://codeberg.org/HeartBlin/Hyperbolic";
              allow_runtime_mutation = true;
            }
          ];
        };
      };
    };

    caddy.virtualHosts = {
      "ci.${domain}".extraConfig = mTLS "reverse_proxy http://[::1]:3000";
      "cache.${domain}".extraConfig = ''
        handle /nix-cache/* {
          reverse_proxy [::1]:3000
        }

        handle {
          respond 404
        }
      '';
    };
  };
}
