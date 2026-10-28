{ self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    chromium
    gaming
    ghostty
    git
    mangohud
    nh
    shell
    vscodium

    # Core
    bootloader
    chrony
    nix
    user
    zswap

    # Extras
    ./extras/disko.nix
    ./extras/networking.nix
  ];

  ## Module overrides
  # user.nix
  users.users.primaryUser = {
    name = "heartblin";
    description = "HeartBlin";
  };

  ## Host specifics
  # Identity
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
