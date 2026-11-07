{
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;
    powerManagement.enable = true;
    dynamicBoost.enable = true;
    branch = "bleeding_edge";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
