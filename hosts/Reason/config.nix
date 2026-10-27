{ inputs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    nh

    # Core
    bootloader
    user

    # Extras
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  ## Module overrides
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [ (builtins.readFile ./Void.pub) ];
  };

  ## Host specifics
  # Identity
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
