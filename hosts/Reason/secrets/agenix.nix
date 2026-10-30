{ inputs, self, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];
  age.secrets = let
    path = "${self}/hosts/Reason/secrets";
  in {
    beszel.file = "${path}/beszel.age";
    caddy.file = "${path}/caddy.age";
    ddns-updater.file = "${path}/ddns-updater.json.age";
    slskd.file = "${path}/slskd.age";
  };
}
