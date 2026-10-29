{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    null.url = "git+https://codeberg.org/HeartBlin/Null.git";
    aequor.url = "github:HeartBlin/Verneuil";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.pre-commit.follows = "null";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs) self;
    inherit (inputs.nixpkgs) lib;
    forAllSystems = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
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

    packages = forAllSystems (system: let
      inherit (lib) readDir filterAttrs;
      inherit (pkgs) callPackage;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      ./packages
      |> readDir
      |> filterAttrs (_: type: type == "directory")
      |> builtins.mapAttrs (name: _: callPackage "${inputs.self}/packages/${name}" { }));
  };
}
