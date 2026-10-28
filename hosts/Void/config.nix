{ inputs, pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    chromium
    gaming
    ghostty
    git
    mangohud
    nh
    shell
    vscodium

    # Core
    bootloader
    chrony
    nix
    user
    zswap

    # Desktop
    gnome

    # Hardware
    amd
    asus
    audio
    bluetooth

    # Security
    keys

    # Extras
    ./extras/disko.nix
    ./extras/networking.nix
  ];

  ## Module overrides
  # nvidia.nix
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:5@0:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  # user.nix
  users.users.primaryUser = {
    name = "heartblin";
    description = "HeartBlin";
  };

  ## Host specifics
  # My left arrow key is broken. Remap to right control, and disable it
  services.udev.extraHwdb = ''
    evdev:input:b0003v0B05p1866*
      KEYBOARD_KEY_700e4=left
      KEYBOARD_KEY_70050=reserved
  '';

  # Kernel changes
  boot = {
    kernelPackages = pkgs.linuxPackagesFor inputs.aequor.packages."x86_64-linux".linux-alexandrite;
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  # Identity
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
