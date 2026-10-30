{ inputs, self, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];
  age.secrets.caddy.file = "${self}/hosts/Reason/secrets/caddy.age";
}
