{ inputs, self, ... }:

{
  # Modules
  imports = with self.nixosModules; [
    bootloader

    # Extras
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  # Host identity
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
