{ inputs, self, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];
  age.secrets = let
    path = "${self}/hosts/Reason/secrets";
  in {
    caddy.file = "${path}/caddy.age";
    ddns-updater.file = "${path}/ddns-updater.json.age";
  };
}
