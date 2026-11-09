{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;
    powerManagement.enable = true;
    dynamicBoost.enable = true;
    branch = "bleeding_edge";
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "620.70.06";
      sha256_64bit = "sha256-KRGOOr0IwHVZvMo9nHYjjQOUkK8DYqLlvPy+cgSv1LE=";
      sha256_aarch64 = "";
      openSha256 = "sha256-dV8vzniUl3UJoG2Q3KdoUJigLRuQeTniUfB670gb1Mw=";
      settingsSha256 = "";
      persistencedSha256 = "";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
