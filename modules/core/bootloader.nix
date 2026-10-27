{ inputs, pkgs, ... }:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  environment.systemPackages = [ pkgs.sbctl ];
  boot = {
    loader = {
      systemd-boot.enable = false;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
  };
}
