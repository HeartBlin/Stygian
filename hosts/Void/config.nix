{ pkgs, self, ... }:

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
    nvidia

    # Security
    keys

    # Extras
    ./extras/disko.nix
    ./extras/networking.nix
  ];

  ## Module overrides
  # git.nix
  programs.git.config.user = {
    name = "HeartBlin";
    email = "HeartBlin@noreply.codeberg.org";
    signingkey = "/home/heartblin/.ssh/Codeberg";
  };

  # nh.nix
  programs.nh.flake = "/home/heartblin/Projects/Arbor";

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

  # Needs a repaste, it is unstable
  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq - - - - 3700000"
  ];

  # I want fstrim
  services.fstrim.enable = true;

  # I want it to follow EET/EEST
  time.timeZone = "Europe/Bucharest";

  # Kernel changes
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  # SSH Convenience
  programs.ssh.extraConfig = ''
    Host codeberg.org
      HostName codeberg.org
      User git
      IdentityFile /home/heartblin/.ssh/Codeberg
      IdentitiesOnly yes

    Host Reason
      HostName fd71:3362:beef:1::1
      Port 22
      User server
      IdentityFile /home/heartblin/.ssh/Reason
      IdentitiesOnly yes
  '';

  # Identity
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
