let
  osDisk = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNX1W519812T";
in {
  fileSystems = {
    "/boot" = {
      device = "${osDisk}-part1";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/" = {
      device = "/dev/mapper/crypted";
      fsType = "xfs";
      options = [ "defaults" "pquota" ];
    };
  };

  boot = {
    resumeDevice = "${osDisk}-part2";
    initrd.luks.devices."crypted" = {
      device = "${osDisk}-part3";
      allowDiscards = true;
      crypttabExtraOpts = [ "fido2-device=auto" ];
    };
  };

  swapDevices = [
    {
      device = "${osDisk}-part2";
      discardPolicy = "both";
    }
  ];
}
