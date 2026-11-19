{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.dix ];
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
    };
  };
}
