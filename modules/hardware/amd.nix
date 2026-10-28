{
  boot = {
    kernelParams = [ "amd_pstate=active" ];
    kernelModules = [
      "kvm-amd"
      "amd-pstate"
    ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
