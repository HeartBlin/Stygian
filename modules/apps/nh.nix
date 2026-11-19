{ lib, pkgs, ... }:

{
  environment = {
    systemPackages = [ pkgs.dix ];
    sessionVariables.NH_ELEVATION_STRATEGY = "program:${
      lib.getExe' pkgs.polkit "run0"
    }";
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
    };
  };
}
