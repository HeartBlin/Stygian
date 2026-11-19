{
  outputs = { self }: let
    inputs = import ./.tack;
    inherit (inputs.nixpkgs) lib;
  in {
    # Find all hosts
    nixosConfigurations = with lib;
      readDir ./hosts
      |> filterAttrs (n: v: v == "directory" && pathExists ./hosts/${n}/config.nix)
      |> mapAttrs (host: _: nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ ./hosts/${host}/config.nix ];
      });

    # Find all modules
    nixosModules = with lib;
      ./modules
      |> filesystem.listFilesRecursive
      |> filter (p: hasSuffix ".nix" p && !hasInfix "/_" (removePrefix (toString ./modules) (toString p)))
      |> groupBy (p: removeSuffix ".nix" (baseNameOf p))
      |> mapAttrs (k: v:
        if length v == 1
        then head v
        else throw "Duplicate '${k}': ${toString v}");

    # For `nix flake checks`
    checks = lib.genAttrs [ "x86_64-linux" ] (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      overall = pkgs.writeShellApplication {
        name = "check";
        text = ''
          deadnix --fail .
          statix check . \
            -i hosts/Reason/config.nix \
            -i hosts/Void/config.nix
        '';

        runtimeInputs = [
          pkgs.deadnix
          pkgs.statix
        ];
      };
    });
  };
}
