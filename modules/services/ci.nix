{ config, ... }:

let
  inherit (config.nix.settings) experimental-features;
  inherit (config.nix) package;
in {
  containers.nymph = {
    autoStart = true;
    bindMounts."/run/secrets/ci" = {
      hostPath = config.age.secrets.ci.path;
      isReadOnly = true;
    };

    config = _: {
      system.stateVersion = "26.11";
      nix.settings = { inherit experimental-features; };
      services.forgejo-runner.instances.nymph = {
        enable = true;
        secrets.server.connections.codeberg.token_url = "/run/secrets/ci";
        hostPackages = [ package ];
        settings = {
          server.connections.codeberg = {
            url = "https://codeberg.org";
            uuid = "48112d2f-046a-4b6f-8119-d936c258ae3f";
          };

          runner = {
            capacity = 1;
            labels = [ "nixos-nymph:host" ];
          };
        };
      };
    };
  };
}
