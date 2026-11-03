let
  osDisk = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_BTKA20450EZM512A";
  dataDisk = "/dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7784CD5F58";
in {
  fileSystems = {
    "/boot" = {
      device = "${osDisk}-part1";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/" = {
      device = "${osDisk}-part3";
      fsType = "btrfs";
      options = [ "subvol=/root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "${osDisk}-part3";
      fsType = "btrfs";
      options = [ "subvol=/nix" "compress=zstd" "noatime" ];
    };

    "/var/log" = {
      device = "${osDisk}-part3";
      fsType = "btrfs";
      options = [ "subvol=/log" "compress=zstd" "noatime" ];
    };

    "/var/lib" = {
      device = "${osDisk}-part3";
      fsType = "btrfs";
      options = [ "subvol=/var-lib" "compress=zstd" "noatime" ];
    };

    "/data" = {
      device = "${dataDisk}-part1";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd" ];
    };

    "/data/music" = {
      device = "${dataDisk}-part1";
      fsType = "btrfs";
      options = [ "subvol=/music" "compress=zstd" "noatime" ];
    };

    "/data/store" = {
      device = "${dataDisk}-part1";
      fsType = "btrfs";
      options = [ "subvol=/store" "compress=zstd" "noatime" ];
    };

    "/data/vaultwarden" = {
      device = "${dataDisk}-part1";
      fsType = "btrfs";
      options = [ "subvol=/vaultwarden" "compress=zstd" "noatime" ];
    };
  };

  boot.resumeDevice = "${osDisk}-part2";
  swapDevices = [
    {
      device = "${osDisk}-part2";
      discardPolicy = "both";
    }
  ];
}
