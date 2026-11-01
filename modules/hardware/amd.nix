{
  boot = {
    kernelParams = [ "amd_pstate=active" ];
    kernelModules = [
      "kvm-amd"
      "amd-pstate"
      "amdgpu"
    ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
