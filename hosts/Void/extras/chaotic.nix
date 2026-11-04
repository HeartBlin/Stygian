{ inputs, pkgs, ... }:

{
  imports = [ inputs.chaotic.nixosModules.default ];
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  chaotic.mesa-git.enable = true;
  programs.steam.extraCompatPackages = [
    pkgs.proton-cachyos_x86_64_v3
  ];
}
