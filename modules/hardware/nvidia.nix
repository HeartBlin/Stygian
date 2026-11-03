{ config, lib, ... }:

let
  default = lib.elem "nouveau" config.services.xserver.videoDrivers;
in {
  services.xserver.videoDrivers = [ "nouveau" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot = lib.mkIf default {
    kernelParams = [ "nouveau.config=NvGspRm=1" ];
    kernelModules = [ "nouveau" ];
  };

  specialisation.nvidia.configuration = {
    system.nixos.tags = [ "nvidia" ];
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
    hardware.nvidia = {
      branch = "bleeding_edge";
      open = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
    };

    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
    ];
  };
}
