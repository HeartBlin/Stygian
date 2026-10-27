{ self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    nh

    # Core
    bootloader
    chrony
    nix
    user

    # Extras
    ./extras/disko.nix
    ./extras/networking.nix
  ];

  ## Module overrides
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [ (builtins.readFile ./extras/Void.pub) ];
  };

  ## Host specifics
  # Identity
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
