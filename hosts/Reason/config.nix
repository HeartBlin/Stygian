{ pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    nh
    shell

    # Core
    bootloader
    chrony
    nix
    user
    zswap

    # Hardware
    amd

    # Services
    caddy
    ddns-updater
    vaultwarden

    # Extras
    ./extras/disko.nix
    ./extras/networking.nix
    ./extras/openssh.nix

    # Secrets
    ./secrets/agenix.nix
  ];

  ## Module overrides
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [ (builtins.readFile ./extras/Void.pub) ];
  };

  ## Host specifics
  # Folders and Permissions
  users.groups = {
    store = { gid = 100001; };
    music = { gid = 100002; };
  };

  systemd.tmpfiles.rules = [
    "z /data/music 2770 root music"
    "z /data/store 2770 root store"
  ];

  # I want fstrim
  services.fstrim.enable = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # I want Mesa
  hardware.graphics.enable = true;

  # Identity
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
