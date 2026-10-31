{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    null.url = "git+https://codeberg.org/HeartBlin/Null.git";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "null";
      };
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs) self;
    inherit (inputs.nixpkgs) lib;
    forAllSystems = lib.genAttrs [ "x86_64-linux" ];
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

    # Find all packages
    packages = forAllSystems (system: let
      inherit (lib) readDir filterAttrs;
      inherit (pkgs) callPackage;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      ./packages
      |> readDir
      |> filterAttrs (_: type: type == "directory")
      |> builtins.mapAttrs (name: _: callPackage "${inputs.self}/packages/${name}" { }));

    # For `nix flake checks`
    checks = forAllSystems (system: let
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
