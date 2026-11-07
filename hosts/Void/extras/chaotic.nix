{ inputs, pkgs, ... }:

{
  imports = [ inputs.chaotic.nixosModules.default ];
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  programs.steam.extraCompatPackages = [ pkgs.proton-cachyos_x86_64_v3 ];
  hardware.nvidia.package = pkgs.nvidia_cachyos-lto;
}
