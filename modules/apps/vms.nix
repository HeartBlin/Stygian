{ pkgs, self, ... }:

{
  virtualisation.libvirtd .enable = true;
  users.users.primaryUser.extraGroups = [ "libvirtd" ];
  environment.systemPackages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.gnome-boxes-nightly
    pkgs.passt
  ];
}
