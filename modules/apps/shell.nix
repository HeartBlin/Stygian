{ inputs, lib, pkgs, ... }:

{
  imports = [ inputs.nix-index-database.nixosModules.default ];

  users.users.primaryUser.shell = pkgs.fish;
  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
      shellAliases.ls = "${lib.getExe pkgs.eza} -l --icons --git";
      interactiveShellInit = "set -g fish_greeting";
    };

    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$character";
        add_newline = false;
        character = {
          success_symbol = "[λ](bold purple)";
          error_symbol = "[λ](bold red)";
        };
      };
    };

    zoxide = {
      enable = true;
      flags = [ "--cmd cd" ];
    };

    nix-index-database.comma.enable = true;
    nix-index.package = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;
  };
}
