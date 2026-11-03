{
  boot.kernelParams = [ "i8042.nokbd" ];
  services = {
    asusd.enable = true;
    supergfxd.enable = false;
  };
}
